import 'dart:convert';

import '../../amount_text.dart';
import '../../data/database.dart';
import 'draft_problem.dart';

/// Tax rates the enrichment uses when a line doesn't set them
abstract final class TaxRates {
  static const igv = '0.18';

  /// ICBPER per plastic bag since 2023
  static const icb = '0.50';
  static const ivap = '0.04';
}

/// A line of an invoice being written
class DraftLine {
  const DraftLine({
    required this.descripcion,
    required this.cantidad,
    required this.precio,
    this.precioIncluyeIgv = true,
    this.unidadMedida = 'NIU',
    this.igvTipo = '10',
    this.codigo,
    this.codigoSunat,
    this.iscTipo,
    this.iscTasa,
    this.esBolsa = false,
    this.detraccionCodigo,
    this.detraccionPorcentaje,
  });

  factory DraftLine.fromProduct(Product product, {required String igvTipo}) =>
      DraftLine(
        descripcion: product.descripcion,
        cantidad: '1',
        precio: product.precio,
        precioIncluyeIgv: product.precioIncluyeIgv,
        unidadMedida: product.unidadMedida,
        igvTipo: product.igvTipo ?? igvTipo,
        codigo: product.codigo,
        codigoSunat: product.codigoSunat,
        iscTipo: product.iscTipo,
        iscTasa: product.iscTasa,
        esBolsa: product.esBolsa,
        detraccionCodigo: product.detraccionCodigo,
        detraccionPorcentaje: product.detraccionPorcentaje,
      );

  /// A line of a stored document's input (xbuilder `detalles`), e.g. to
  /// copy it into a nota de crédito
  factory DraftLine.fromJson(Map<String, Object?> json) {
    final precioConImpuestos = json['precio_con_impuestos'] as String?;
    final tasa = json['isc_tasa'] as String?;
    return DraftLine(
      descripcion: json['descripcion']! as String,
      cantidad: '${json['cantidad']}',
      precio: precioConImpuestos ?? '${json['precio']}',
      precioIncluyeIgv: precioConImpuestos != null,
      unidadMedida: json['unidad_medida'] as String? ?? 'NIU',
      igvTipo: json['igv_tipo'] as String? ?? '10',
      codigo: json['codigo'] as String?,
      codigoSunat: json['codigo_sunat'] as String?,
      iscTipo: json['isc_tipo'] as String?,
      // Stored as xbuilder's fraction: back to a percentage
      iscTasa: tasa == null ? null : fractionToPercent(tasa),
      esBolsa: json['icb_aplica'] as bool? ?? false,
    );
  }

  final String descripcion;

  /// Decimals as text, to keep them exact
  final String cantidad;
  final String precio;
  final bool precioIncluyeIgv;
  final String unidadMedida;
  final String igvTipo;
  final String? codigo;
  final String? codigoSunat;
  final String? iscTipo;

  /// Percentage, e.g. "17"
  final String? iscTasa;
  final bool esBolsa;

  /// Catalog 54 code and rate (a percentage) of a product subject to
  /// detracción; they go in the invoice's `detraccion`, not the line
  final String? detraccionCodigo;
  final String? detraccionPorcentaje;

  DraftLine copyWith({
    String? descripcion,
    String? cantidad,
    String? precio,
    String? unidadMedida,
  }) => DraftLine(
    descripcion: descripcion ?? this.descripcion,
    cantidad: cantidad ?? this.cantidad,
    precio: precio ?? this.precio,
    precioIncluyeIgv: precioIncluyeIgv,
    unidadMedida: unidadMedida ?? this.unidadMedida,
    igvTipo: igvTipo,
    codigo: codigo,
    codigoSunat: codigoSunat,
    iscTipo: iscTipo,
    iscTasa: iscTasa,
    esBolsa: esBolsa,
    detraccionCodigo: detraccionCodigo,
    detraccionPorcentaje: detraccionPorcentaje,
  );

  Map<String, Object?> toJson() => {
    'descripcion': descripcion,
    'cantidad': cantidad,
    'unidad_medida': unidadMedida,
    if (precioIncluyeIgv) 'precio_con_impuestos': precio else 'precio': precio,
    'igv_tipo': igvTipo,
    'codigo': ?codigo,
    'codigo_sunat': ?codigoSunat,
    'isc_tipo': ?iscTipo,
    if (iscTasa case final tasa?) 'isc_tasa': percentToFraction(tasa),
    'icb_aplica': esBolsa,
  };
}

/// Who the invoice is for
class DraftCustomer {
  const DraftCustomer({
    required this.tipoDocumentoIdentidad,
    required this.numeroDocumentoIdentidad,
    required this.nombre,
    this.direccion,
    this.distrito,
    this.provincia,
    this.departamento,
    this.ubigeo,
    this.email,
  });

  factory DraftCustomer.fromCustomer(Customer customer) => DraftCustomer(
    tipoDocumentoIdentidad: customer.tipoDocumentoIdentidad,
    numeroDocumentoIdentidad: customer.numeroDocumentoIdentidad,
    nombre: customer.nombre,
    direccion: customer.direccion,
    distrito: customer.distrito,
    provincia: customer.provincia,
    departamento: customer.departamento,
    ubigeo: customer.ubigeo,
    email: customer.email,
  );

  /// A stored document's customer (xbuilder `cliente`), e.g. for its notas
  factory DraftCustomer.fromJson(Map<String, Object?> json) {
    final direccion = json['direccion'] as Map<String, Object?>? ?? const {};
    final contacto = json['contacto'] as Map<String, Object?>? ?? const {};
    return DraftCustomer(
      tipoDocumentoIdentidad: json['tipo_documento_identidad']! as String,
      numeroDocumentoIdentidad: json['numero_documento_identidad']! as String,
      nombre: json['nombre']! as String,
      direccion: direccion['direccion'] as String?,
      distrito: direccion['distrito'] as String?,
      provincia: direccion['provincia'] as String?,
      departamento: direccion['departamento'] as String?,
      ubigeo: direccion['ubigeo'] as String?,
      email: contacto['email'] as String?,
    );
  }

  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String nombre;
  final String? direccion;
  final String? distrito;
  final String? provincia;
  final String? departamento;
  final String? ubigeo;
  final String? email;

  /// "Clientes varios": customer type "0" with number "-"
  bool get isAnonymous =>
      tipoDocumentoIdentidad == '0' && numeroDocumentoIdentidad == '-';

  Map<String, Object?> toJson() {
    final address = {
      'direccion': ?direccion,
      'distrito': ?distrito,
      'provincia': ?provincia,
      'departamento': ?departamento,
      'ubigeo': ?ubigeo,
    };
    return {
      'tipo_documento_identidad': tipoDocumentoIdentidad,
      'numero_documento_identidad': numeroDocumentoIdentidad,
      'nombre': nombre,
      if (address.isNotEmpty) 'direccion': address,
      if (email != null) 'contacto': {'email': email},
    };
  }
}

/// Customer of boletas to people who don't identify themselves (accepted by
/// SUNAT for sales up to S/ 700)
const anonymousCustomer = DraftCustomer(
  tipoDocumentoIdentidad: '0',
  numeroDocumentoIdentidad: '-',
  nombre: 'CLIENTES VARIOS',
);

/// Boletas over S/ 700 need an identified customer. Only soles are checked:
/// other currencies need an exchange rate, not supported yet.
bool exceedsAnonymousLimit(
  DraftCustomer customer,
  String moneda,
  String total,
) => customer.isAnonymous && moneda == 'PEN' && toCents(total) > toCents('700');

/// Payment in installments ("crédito")
class DraftCuota {
  const DraftCuota({required this.importe, required this.fechaPago});

  final String importe;

  /// "YYYY-MM-DD"
  final String fechaPago;
}

/// What [DocumentService.emit] issues: a document of the company with its
/// customer and lines
abstract interface class DocumentDraft {
  /// Catalog 1
  String get tipoComprobante;
  DraftCustomer get customer;
  String get moneda;

  /// The document a nota modifies, `null` for invoices
  String? get affectedDocumentId;

  /// Why it can't be issued, checked before taking a number
  DraftProblem? get problem;

  /// The document's total, from its enriched xbuilder `spec`
  String totalOf(Map<String, Object?> enrichedSpec);

  /// The xbuilder document (`{"kind": ..., "spec": {...}}`)
  String toDocumentJson({
    required Company company,
    required String serieNumero,
    required String fechaEmision,
  });
}

/// The company as xbuilder's `proveedor`
Map<String, Object?> proveedorJson(Company company) {
  String? text(String? value) => value == null || value.isEmpty ? null : value;
  final direccion = {
    'ubigeo': text(company.ubigeo),
    'departamento': text(company.departamento),
    'provincia': text(company.provincia),
    'distrito': text(company.distrito),
    'direccion': text(company.direccion),
    'urbanizacion': text(company.urbanizacion),
    'codigo_local': text(company.codigoLocal),
  }..removeWhere((_, value) => value == null);
  final contacto = {
    'telefono': text(company.telefono),
    'email': text(company.email),
  }..removeWhere((_, value) => value == null);
  return {
    'ruc': company.ruc,
    'razon_social': company.razonSocial,
    'nombre_comercial': ?text(company.nombreComercial),
    if (direccion.isNotEmpty) 'direccion': direccion,
    if (contacto.isNotEmpty) 'contacto': contacto,
  };
}

/// The total of invoices and notas, from their enriched `spec`
String _importeTotal(Map<String, Object?> spec) =>
    '${(spec['total_importe']! as Map)['importe']}';

/// An invoice (factura or boleta) being written
class InvoiceDraft implements DocumentDraft {
  const InvoiceDraft({
    required this.tipoComprobante,
    required this.customer,
    required this.lines,
    required this.moneda,
    this.cuotas = const [],
    this.detraccionMonto,
  });

  /// Catalog 1: "01" factura, "03" boleta
  @override
  final String tipoComprobante;
  @override
  final DraftCustomer customer;
  final List<DraftLine> lines;
  @override
  final String moneda;

  /// Empty for payment in full ("contado")
  final List<DraftCuota> cuotas;

  /// The detracción it carries, of [detraccionLine]. Only facturas in soles
  /// over [detraccionThreshold] do, and the total is known once built, so
  /// the document service sets it ([withDetraccionOn]).
  final String? detraccionMonto;

  /// The line whose detracción the factura carries: SUNAT takes one per
  /// factura, and with several the highest rate is used (DESIGN §5)
  DraftLine? get detraccionLine {
    DraftLine? highest;
    for (final line in lines) {
      final rate = line.detraccionPorcentaje;
      if (line.detraccionCodigo == null || rate == null) continue;
      if (highest == null ||
          toCents(rate) > toCents(highest.detraccionPorcentaje!)) {
        highest = line;
      }
    }
    return highest;
  }

  /// Whether a detracción applies once the total is over
  /// [detraccionThreshold]
  bool get subjectToDetraccion =>
      tipoComprobante == '01' && moneda == 'PEN' && detraccionLine != null;

  /// Total from which the detracción applies: S/ 400 for transporte de bienes
  /// (027), S/ 700 for the rest (DESIGN §14 lists what to confirm)
  String get detraccionThreshold =>
      detraccionLine?.detraccionCodigo == '027' ? '400' : '700';

  /// This draft with the detracción on [total] (with taxes), half up to
  /// cents. xbuilder keeps the given amount, so the XML, the installments
  /// and the printed document all use this one.
  InvoiceDraft withDetraccionOn(String total) {
    final rate = toCents(detraccionLine!.detraccionPorcentaje!); // in 1/100 %
    final monto =
        (toCents(total) * rate + BigInt.from(5000)) ~/ BigInt.from(10000);
    // Every field: one added to InvoiceDraft must be copied here too
    return InvoiceDraft(
      tipoComprobante: tipoComprobante,
      customer: customer,
      lines: lines,
      moneda: moneda,
      cuotas: cuotas,
      detraccionMonto: fromCents(monto),
    );
  }

  @override
  String? get affectedDocumentId => null;

  @override
  DraftProblem? get problem {
    if (lines.isEmpty) return DraftProblem.noLines;
    if (tipoComprobante == '01' && customer.tipoDocumentoIdentidad != '6') {
      return DraftProblem.facturaWithoutRuc;
    }
    return null;
  }

  @override
  String totalOf(Map<String, Object?> enrichedSpec) =>
      _importeTotal(enrichedSpec);

  @override
  String toDocumentJson({
    required Company company,
    required String serieNumero,
    required String fechaEmision,
  }) => jsonEncode({
    'kind': 'Invoice',
    'spec': {
      'serie_numero': serieNumero,
      'tipo_comprobante': tipoComprobante,
      'fecha_emision': fechaEmision,
      'moneda': moneda,
      'proveedor': proveedorJson(company),
      'cliente': customer.toJson(),
      'detalles': [for (final line in lines) line.toJson()],
      if (detraccionMonto case final monto?)
        if (detraccionLine case final line?)
          'detraccion': {
            // Catalog 59: deposit in the Banco de la Nación account
            'medio_pago': '001',
            'cuenta_bancaria': company.cuentaDetracciones,
            'tipo_bien_detraido': line.detraccionCodigo,
            'porcentaje': percentToFraction(line.detraccionPorcentaje!),
            'monto': monto,
          },
      'forma_pago': cuotas.isEmpty
          ? {'tipo': 'Contado'}
          : {
              'tipo': 'Credito',
              'cuotas': [
                for (final cuota in cuotas)
                  {'importe': cuota.importe, 'fecha_pago': cuota.fechaPago},
              ],
            },
    },
  });
}

/// A nota de crédito ("07") or débito ("08") of an issued invoice
class NoteDraft implements DocumentDraft {
  const NoteDraft({
    required this.tipoComprobante,
    required this.affected,
    required this.tipoNota,
    required this.sustento,
    required this.customer,
    required this.lines,
  }) : assert(tipoComprobante == '07' || tipoComprobante == '08');

  @override
  final String tipoComprobante;

  /// The invoice it modifies
  final Document affected;

  /// Catalog 9 (crédito) or 10 (débito)
  final String tipoNota;

  /// Why it's issued, as SUNAT asks
  final String sustento;
  @override
  final DraftCustomer customer;
  final List<DraftLine> lines;

  @override
  String get moneda => affected.moneda;

  @override
  String? get affectedDocumentId => affected.id;

  @override
  DraftProblem? get problem => lines.isEmpty ? DraftProblem.noLines : null;

  @override
  String totalOf(Map<String, Object?> enrichedSpec) =>
      _importeTotal(enrichedSpec);

  @override
  String toDocumentJson({
    required Company company,
    required String serieNumero,
    required String fechaEmision,
  }) => jsonEncode({
    'kind': tipoComprobante == '07' ? 'CreditNote' : 'DebitNote',
    'spec': {
      'serie_numero': serieNumero,
      'fecha_emision': fechaEmision,
      'moneda': moneda,
      'proveedor': proveedorJson(company),
      'cliente': customer.toJson(),
      'tipo_nota': tipoNota,
      'comprobante_afectado_tipo': affected.tipoComprobante,
      'comprobante_afectado_serie_numero':
          '${affected.serie}-${affected.numero}',
      'descripcion_sustento': sustento,
      'detalles': [for (final line in lines) line.toJson()],
    },
  });
}

/// What the notas de crédito among [related] (the documents that modify
/// an invoice) credit, unless SUNAT rejected or voided them
BigInt creditedCents(Iterable<Document> related) => related
    .where(
      (d) =>
          d.tipoComprobante == '07' &&
          d.status != DocumentStatus.rejected &&
          d.status != DocumentStatus.voided,
    )
    .fold(BigInt.zero, (sum, d) => sum + toCents(d.total));
