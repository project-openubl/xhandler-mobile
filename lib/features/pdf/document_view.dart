import 'dart:convert';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../src/rust/api/sunat.dart';
import '../document/document_status.dart';
import '../document/document_totals.dart';
import '../document/sunat_answer.dart';
import 'amount_words.dart';

/// A line as printed: [precio] and [importe] are `null` on guías
class ViewLine {
  const ViewLine({
    required this.cantidad,
    required this.unidad,
    required this.descripcion,
    this.precio,
    this.importe,
  });

  final String cantidad;
  final String unidad;
  final String descripcion;
  final String? precio;
  final String? importe;
}

/// A document ready to print: every text and amount already formatted, so
/// templates only lay it out (docs/DESIGN.md §7.1)
class DocumentView {
  const DocumentView({
    required this.title,
    required this.serieNumero,
    required this.fechaEmision,
    required this.companyName,
    required this.ruc,
    required this.header,
    required this.lines,
    required this.totals,
    required this.notes,
    required this.footer,
    this.companyCommercialName,
    this.companyAddress,
    this.total,
    this.amountInWords,
    this.qr,
    this.pending = false,
    this.testMode = false,
  });

  /// "FACTURA ELECTRÓNICA"
  final String title;
  final String serieNumero;
  final String fechaEmision;
  final String companyName;
  final String? companyCommercialName;
  final String ruc;
  final String? companyAddress;

  /// Label and value rows under the title: customer, currency, motivo...
  final List<(String, String)> header;
  final List<ViewLine> lines;

  /// Label and amount rows above the total
  final List<(String, String)> totals;
  final String? total;
  final String? amountInWords;

  /// Installments, observations...
  final List<String> notes;

  /// SUNAT's QR code contents
  final String? qr;

  /// SUNAT hasn't received it yet
  final bool pending;

  /// Issued in test mode (SUNAT beta): not a valid document
  final bool testMode;
  final String footer;

  bool get showPrices => lines.any((line) => line.importe != null);
}

/// Where anyone can check a document SUNAT received
const consultaUrl =
    'https://ww1.sunat.gob.pe/ol-ti-itconsvalicpe/ConsValiCpe.htm';

/// SUNAT's name of each printable document, and its article
const _titles = {
  '01': ('FACTURA ELECTRÓNICA', 'la'),
  '03': ('BOLETA DE VENTA ELECTRÓNICA', 'la'),
  '07': ('NOTA DE CRÉDITO ELECTRÓNICA', 'la'),
  '08': ('NOTA DE DÉBITO ELECTRÓNICA', 'la'),
  '09': ('GUÍA DE REMISIÓN ELECTRÓNICA REMITENTE', 'la'),
  '20': ('COMPROBANTE DE RETENCIÓN ELECTRÓNICO', 'del'),
  '40': ('COMPROBANTE DE PERCEPCIÓN ELECTRÓNICO', 'del'),
};

/// Statuses whose documents can be printed: accepted, or still waiting
/// for SUNAT (with a banner). Rejected and voided ones aren't valid.
const _printableStatuses = {
  DocumentStatus.accepted,
  DocumentStatus.acceptedWithObservations,
  DocumentStatus.pendingSend,
  DocumentStatus.inProgress,
};

/// Whether [document] has a valid printed representation. Voiding
/// documents have none; guías need the QR SUNAT returns in their CDR, not
/// read yet (docs/DESIGN.md §14).
bool hasPrintedView(Document document) =>
    _titles.containsKey(document.tipoComprobante) &&
    document.tipoComprobante != '09' &&
    _printableStatuses.contains(document.status);

/// The printed view of [document], issued by [company]
DocumentView documentView(Document document, Company company) {
  final spec =
      (jsonDecode(document.enrichedJson) as Map<String, Object?>)['spec']!
          as Map<String, Object?>;
  final (title, article) = _titles[document.tipoComprobante]!;
  final address = [
    company.direccion,
    company.distrito,
    company.provincia,
    company.departamento,
  ].where((part) => part != null && part.isNotEmpty).join(', ');
  final (header, lines, totals, notes) = switch (document.tipoComprobante) {
    '09' => _guia(spec),
    '20' || '40' => _perceptionRetention(document, spec),
    _ => _invoice(document, spec),
  };
  final hasAmounts = document.tipoComprobante != '09';
  final isPerceptionRetention = const {
    '20',
    '40',
  }.contains(document.tipoComprobante);
  return DocumentView(
    title: title,
    serieNumero: serieNumero(document.serie, document.numero),
    fechaEmision: document.fechaEmision,
    companyName: company.razonSocial,
    companyCommercialName: company.nombreComercial,
    ruc: company.ruc,
    companyAddress: address.isEmpty ? null : address,
    header: header,
    lines: lines,
    totals: totals,
    // Percepciones and retenciones show their amount among the totals
    total: hasAmounts && !isPerceptionRetention
        ? formatMoney(document.moneda, document.total)
        : null,
    amountInWords: hasAmounts
        ? 'SON: ${amountInWords(document.total, document.moneda)}'
        : null,
    notes: notes,
    qr: const {'01', '03', '07', '08'}.contains(document.tipoComprobante)
        ? _qr(document, company, spec)
        : null,
    pending: !acceptedStatuses.contains(document.status),
    testMode: document.environment == SunatEnvironment.beta,
    footer:
        'Representación impresa $article ${title.toLowerCase()}. '
        'Consulte su validez en $consultaUrl',
  );
}

typedef _Parts = (
  List<(String, String)> header,
  List<ViewLine> lines,
  List<(String, String)> totals,
  List<String> notes,
);

String _identity(Map<String, Object?> party) {
  final tipo = '${party['tipo_documento_identidad']}';
  return '${Catalogs.tiposDocumentoIdentidad[tipo] ?? tipo} '
      '${party['numero_documento_identidad']}';
}

String? _address(Map<String, Object?>? party) {
  final direccion = party?['direccion'] as Map<String, Object?>?;
  if (direccion == null) return null;
  final parts = [
    direccion['direccion'],
    direccion['distrito'],
    direccion['provincia'],
    direccion['departamento'],
  ].whereType<String>().where((part) => part.isNotEmpty);
  return parts.isEmpty ? null : parts.join(', ');
}

String _unit(Object? code) => Catalogs.unidadesMedida[code] ?? '$code';

/// "01" → "Factura"
String _tipoName(Object? tipo) => Catalogs.tiposComprobante[tipo] ?? '$tipo';

_Parts _invoice(Document document, Map<String, Object?> spec) {
  final moneda = document.moneda;
  final cliente = spec['cliente']! as Map<String, Object?>;
  final anonymous =
      cliente['tipo_documento_identidad'] == '0' &&
      cliente['numero_documento_identidad'] == '-';
  final header = <(String, String)>[
    ('Cliente', '${cliente['nombre']}'),
    if (!anonymous) ('Documento', _identity(cliente)),
    if (_address(cliente) case final address?) ('Dirección', address),
    ('Moneda', moneda),
  ];
  final notes = <String>[];
  if (spec['forma_pago'] case {'tipo': final String tipo} && final formaPago) {
    final credito = tipo == 'Credito';
    header.addAll([
      ('Forma de pago', credito ? 'Crédito' : 'Contado'),
      // R.S. 193-2020: what's still owed, with its installments
      if (credito)
        (
          'Monto pendiente de pago',
          formatMoney(moneda, roundAmount('${formaPago['total']}')),
        ),
    ]);
    final cuotas = (formaPago['cuotas'] as List?) ?? const [];
    for (final (index, cuota) in cuotas.cast<Map<String, Object?>>().indexed) {
      notes.add(
        'Cuota ${index + 1}: ${formatMoney(moneda, roundAmount('${cuota['importe']}'))}'
        ' vence ${cuota['fecha_pago']}',
      );
    }
  }
  if (spec['comprobante_afectado_serie_numero'] case final String afectado) {
    final tipoNota = '${spec['tipo_nota']}';
    final motivos = document.tipoComprobante == '07'
        ? Catalogs.tiposNotaCredito
        : Catalogs.tiposNotaDebito;
    header.addAll([
      (
        'Documento que modifica',
        '${_tipoName(spec['comprobante_afectado_tipo'])} $afectado',
      ),
      ('Motivo', motivos[tipoNota] ?? tipoNota),
      ('Sustento', '${spec['descripcion_sustento']}'),
    ]);
  }
  final lines = [
    for (final line in (spec['detalles']! as List).cast<Map<String, Object?>>())
      ViewLine(
        cantidad: '${line['cantidad']}',
        unidad: _unit(line['unidad_medida']),
        descripcion: '${line['descripcion']}',
        precio: formatMoney(
          moneda,
          roundAmount('${line['precio_con_impuestos'] ?? 0}'),
        ),
        importe: formatMoney(
          moneda,
          roundAmount(
            addAmounts(
              // The value before taxes (ISC included in the IGV base)
              // (gratuito lines, not offered yet, would need their own)
              '${line['isc_base_imponible'] ?? 0}',
              '${line['total_impuestos'] ?? 0}',
            ),
          ),
        ),
      ),
  ];
  final totals = DocumentTotals(spec.cast<String, dynamic>());
  return (
    header,
    lines,
    [
      for (final (label, amount) in [
        ('Op. gravada', totals.gravado),
        ('Op. exonerada', totals.exonerado),
        ('Op. inafecta', totals.inafecto),
        ('Op. exportación', totals.exportacion),
        ('ISC', totals.isc),
        ('IGV', totals.igv),
        ('ICBPER', totals.icb),
      ])
        if (toCents(amount) != BigInt.zero)
          (label, formatMoney(moneda, amount)),
    ],
    [if (spec['observaciones'] case final String text) text, ...notes],
  );
}

_Parts _perceptionRetention(Document document, Map<String, Object?> spec) {
  final isPercepcion = document.tipoComprobante == '40';
  final cliente = spec['cliente']! as Map<String, Object?>;
  final operacion = spec['operacion']! as Map<String, Object?>;
  final afectado = operacion['comprobante_afectado']! as Map<String, Object?>;
  String money(Object? amount) => formatMoney('PEN', roundAmount('$amount'));
  final regimenes = isPercepcion
      ? Catalogs.tiposRegimenPercepcion
      : Catalogs.tiposRegimenRetencion;
  final regimen = '${spec['tipo_regimen']}';
  return (
    [
      (isPercepcion ? 'Cliente' : 'Proveedor', '${cliente['nombre']}'),
      ('Documento', _identity(cliente)),
      ('Régimen', regimenes[regimen] ?? regimen),
    ],
    [
      ViewLine(
        cantidad: '1',
        unidad: _tipoName(afectado['tipo_comprobante']),
        descripcion:
            '${afectado['serie_numero']} del ${afectado['fecha_emision']}, '
            'total ${money(afectado['importe_total'])}; '
            '${isPercepcion ? 'cobro' : 'pago'} del ${operacion['fecha_operacion']}',
        precio: money(operacion['importe_operacion']),
        importe: money(operacion['importe_operacion']),
      ),
    ],
    [
      if (isPercepcion) ...[
        ('Percibido', money(spec['importe_total_percibido'])),
        ('Total cobrado', money(spec['importe_total_cobrado'])),
      ] else ...[
        ('Retenido', money(spec['importe_total_retenido'])),
        ('Total pagado', money(spec['importe_total_pagado'])),
      ],
    ],
    [if (spec['observaciones'] case final String text) text],
  );
}

_Parts _guia(Map<String, Object?> spec) {
  final destinatario = spec['destinatario']! as Map<String, Object?>;
  final envio = spec['envio']! as Map<String, Object?>;
  String point(Object? value) {
    final point = value! as Map<String, Object?>;
    return '${point['direccion']} (${point['ubigeo']})';
  }

  final motivo = '${envio['tipo_traslado']}';
  final vehiculo = envio['vehiculo'] as Map<String, Object?>?;
  final choferes = (envio['choferes'] as List? ?? const [])
      .cast<Map<String, Object?>>();
  final transportista = envio['transportista'] as Map<String, Object?>?;
  final related = (spec['documentos_adicionales'] as List? ?? const [])
      .cast<Map<String, Object?>>();
  return (
    [
      ('Destinatario', '${destinatario['nombre']}'),
      ('Documento', _identity(destinatario)),
      (
        'Motivo',
        '${Catalogs.motivosTraslado[motivo] ?? motivo}'
            '${envio['motivo_traslado'] == null ? '' : ': ${envio['motivo_traslado']}'}',
      ),
      ('Inicio del traslado', '${envio['fecha_traslado']}'),
      ('Peso bruto', '${envio['peso_total']} kg'),
      if (envio['numero_bultos'] case final bultos?) ('Bultos', '$bultos'),
      ('Partida', point(envio['partida'])),
      ('Llegada', point(envio['destino'])),
      if (transportista != null)
        (
          'Transportista',
          '${transportista['nombre']} (${_identity(transportista)})',
        )
      else if (vehiculo == null)
        ('Transporte', 'Propio, vehículo M1 o L')
      else ...[
        ('Vehículo', '${vehiculo['placa']}'),
        for (final chofer in choferes)
          (
            'Conductor',
            '${chofer['nombres']} ${chofer['apellidos']}, '
                '${_identity(chofer)}, licencia ${chofer['licencia']}',
          ),
      ],
      for (final document in related)
        (
          'Documento relacionado',
          '${_tipoName(document['tipo_documento'])} ${document['numero']}',
        ),
    ],
    [
      for (final item
          in (spec['detalles']! as List).cast<Map<String, Object?>>())
        ViewLine(
          cantidad: '${item['cantidad']}',
          unidad: _unit(item['unidad_medida']),
          descripcion: '${item['descripcion'] ?? item['codigo']}',
        ),
    ],
    const [],
    [if (spec['observaciones'] case final String text) text],
  );
}

/// RUC|TIPO|SERIE|NUMERO|IGV|TOTAL|FECHA|TIPO_DOC|NUM_DOC|HASH|
String _qr(Document document, Company company, Map<String, Object?> spec) {
  final totals = DocumentTotals(spec.cast<String, dynamic>());
  return [
    company.ruc,
    document.tipoComprobante,
    document.serie,
    document.numero,
    totals.igv,
    document.total,
    document.fechaEmision,
    document.clienteTipoDocumento,
    document.clienteNumeroDocumento,
    document.digestValue,
    '',
  ].join('|');
}
