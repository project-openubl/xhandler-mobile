import 'dart:convert';

import '../../amount_text.dart';
import '../../data/database.dart';
import 'invoice_draft.dart';

/// Document types that can be voided: facturas, boletas, their notas,
/// retenciones and percepciones
const voidableTipos = {'01', '03', '07', '08', '20', '40'};

/// Days after its issue date a document can still be voided
const voidingDays = 7;

/// Comunicación de baja: voids facturas and their notas (F series)
const comunicacionBaja = 'RA';

/// Resumen diario: voids boletas and their notas (B series)
const resumenDiario = 'RC';

/// Reversión: voids retenciones and percepciones (R and P series)
const reversion = 'RR';

/// Types of the documents that void others
const voidingTipos = {comunicacionBaja, resumenDiario, reversion};

/// Whether [document], issued on its date, can still be voided on [today]
bool inVoidingTime(Document document, String today) =>
    // Calendar days, in UTC so daylight saving time doesn't count
    DateTime.parse('${today}T00:00Z')
        .difference(DateTime.parse('${document.fechaEmision}T00:00Z'))
        .inDays <=
    voidingDays;

/// The kind of document that voids [document]
String voidingTipo(Document document) => switch (document.serie[0]) {
  'F' => comunicacionBaja,
  'P' || 'R' => reversion,
  _ => resumenDiario,
};

/// Voiding documents are numbered per day: RA-20261113-1, RA-20261113-2...
String voidingSerie(String tipo, String fechaEmision) =>
    '$tipo-${fechaEmision.replaceAll('-', '')}';

/// The comunicación de baja, resumen diario or reversión (xbuilder JSON)
/// that voids
/// [document] for [motivo] (docs/DESIGN.md §5)
String voidingJson({
  required Company company,
  required Document document,
  required String motivo,
  required int numero,
  required String fechaEmision,
}) {
  final header = {
    'numero': numero,
    'fecha_emision': fechaEmision,
    'fecha_emision_comprobantes': document.fechaEmision,
    'proveedor': proveedorJson(company),
  };
  final tipo = voidingTipo(document);
  if (tipo != resumenDiario) {
    return jsonEncode({
      'kind': tipo == reversion ? 'Reversion' : 'VoidedDocuments',
      'spec': {
        ...header,
        'comprobantes': [
          {
            'tipo_comprobante': document.tipoComprobante,
            'serie': document.serie,
            'numero': document.numero,
            'descripcion_sustento': motivo,
          },
        ],
      },
    });
  }

  final input =
      (jsonDecode(document.inputJson) as Map<String, Object?>)['spec']!
          as Map<String, Object?>;
  final enriched =
      (jsonDecode(document.enrichedJson) as Map<String, Object?>)['spec']!
          as Map<String, Object?>;
  final taxes = enriched['total_impuestos']! as Map<String, Object?>;
  String amount(String field) => roundAmount('${taxes[field] ?? 0}');
  final cliente = input['cliente']! as Map<String, Object?>;
  final afectadoTipo = input['comprobante_afectado_tipo'];
  return jsonEncode({
    'kind': 'SummaryDocuments',
    'spec': {
      ...header,
      'moneda': document.moneda,
      'comprobantes': [
        {
          // Catalog 19: 3 = anulado
          'tipo_operacion': '3',
          'comprobante': {
            'tipo_comprobante': document.tipoComprobante,
            'serie_numero': '${document.serie}-${document.numero}',
            'cliente': {
              'tipo_documento_identidad': cliente['tipo_documento_identidad'],
              'numero_documento_identidad':
                  cliente['numero_documento_identidad'],
            },
            if (afectadoTipo != null)
              'comprobante_afectado': {
                'tipo_comprobante': afectadoTipo,
                'serie_numero': input['comprobante_afectado_serie_numero'],
              },
            'valor_venta': {
              'importe_total': document.total,
              'gravado': amount('gravado_base_imponible'),
              'exonerado': amount('exonerado_base_imponible'),
              'inafecto': amount('inafecto_base_imponible'),
              'gratuito': amount('gratuito_base_imponible'),
            },
            'impuestos': {
              'igv': amount('gravado_importe'),
              'icb': amount('icb_importe'),
              'isc': amount('isc_importe'),
              'ivap': amount('ivap_importe'),
            },
          },
        },
      ],
    },
  });
}
