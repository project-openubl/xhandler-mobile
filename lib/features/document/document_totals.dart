import '../../amount_text.dart';

/// Amounts of a document, as SUNAT shows them
class DocumentTotals {
  const DocumentTotals(this._spec);

  /// The enriched document's `spec` (xbuilder JSON)
  final Map<String, dynamic> _spec;

  String _amount(String group, String field) =>
      roundAmount('${(_spec[group] as Map?)?[field] ?? 0}');

  String get gravado => _amount('total_impuestos', 'gravado_base_imponible');
  String get exonerado =>
      _amount('total_impuestos', 'exonerado_base_imponible');
  String get inafecto => _amount('total_impuestos', 'inafecto_base_imponible');
  String get exportacion =>
      _amount('total_impuestos', 'exportacion_base_imponible');
  String get igv => _amount('total_impuestos', 'gravado_importe');
  String get isc => _amount('total_impuestos', 'isc_importe');
  String get icb => _amount('total_impuestos', 'icb_importe');
  String get total => _amount('total_importe', 'importe');
}
