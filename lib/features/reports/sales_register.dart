import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../document/document_status.dart';
import '../document/document_totals.dart';
import '../document/sunat_answer.dart';

/// Document types in the sales register (registro de ventas)
const salesTipos = {'01', '03', '07', '08'};

/// Statuses in the register: every issued document but the rejected ones.
/// Voided ones are listed without amounts; those SUNAT hasn't confirmed
/// yet are listed with their status, so the month isn't silently short.
final salesStatuses = {...DocumentStatus.values}
  ..remove(DocumentStatus.rejected);

/// A document as the sales register lists it. Amounts are in the
/// document's currency; notas de crédito subtract, voided ones are zero.
class SalesRow {
  const SalesRow({
    required this.fechaEmision,
    required this.tipoComprobante,
    required this.serie,
    required this.numero,
    required this.clienteTipoDocumento,
    required this.clienteNumeroDocumento,
    required this.clienteNombre,
    required this.moneda,
    required this.exportacion,
    required this.gravado,
    required this.exonerado,
    required this.inafecto,
    required this.isc,
    required this.igv,
    required this.icb,
    required this.total,
    required this.status,
    this.modifica,
  });

  factory SalesRow.of(Document document) {
    final voided = document.status == DocumentStatus.voided;
    final status = document.status;
    final spec =
        (jsonDecode(document.enrichedJson) as Map<String, Object?>)['spec']
            as Map<String, Object?>;
    final totals = DocumentTotals(spec.cast<String, dynamic>());
    // Notas de crédito take the amount back
    final sign = document.tipoComprobante == '07' ? '-' : '';
    String amount(String value) =>
        voided || toCents(value) == BigInt.zero ? '0.00' : '$sign$value';
    final afectado = spec['comprobante_afectado_serie_numero'];
    return SalesRow(
      fechaEmision: document.fechaEmision,
      tipoComprobante: document.tipoComprobante,
      serie: document.serie,
      numero: document.numero,
      clienteTipoDocumento: document.clienteTipoDocumento,
      clienteNumeroDocumento: document.clienteNumeroDocumento,
      clienteNombre: document.clienteNombre,
      moneda: document.moneda,
      exportacion: amount(totals.exportacion),
      gravado: amount(totals.gravado),
      exonerado: amount(totals.exonerado),
      inafecto: amount(totals.inafecto),
      isc: amount(totals.isc),
      igv: amount(totals.igv),
      icb: amount(totals.icb),
      total: amount(roundAmount(document.total)),
      status: status,
      modifica: afectado is String
          ? '${spec['comprobante_afectado_tipo']} $afectado'
          : null,
    );
  }

  final String fechaEmision;
  final String tipoComprobante;
  final String serie;
  final int numero;
  final String clienteTipoDocumento;
  final String clienteNumeroDocumento;
  final String clienteNombre;
  final String moneda;
  final String exportacion;
  final String gravado;
  final String exonerado;
  final String inafecto;
  final String isc;
  final String igv;
  final String icb;
  final String total;
  final DocumentStatus status;

  bool get voided => status == DocumentStatus.voided;

  /// SUNAT hasn't confirmed it yet (or its voiding)
  bool get unconfirmed => !voided && !acceptedStatuses.contains(status);

  /// The document a nota modifies: "01 F001-1"
  final String? modifica;
}

/// A register column: its title and whether it holds an amount
typedef _Column = ({
  String title,
  bool amount,
  Object Function(SalesRow) value,
});

final List<_Column> _columns = [
  (title: 'Fecha', amount: false, value: (row) => row.fechaEmision),
  (title: 'Tipo', amount: false, value: (row) => row.tipoComprobante),
  (
    title: 'Comprobante',
    amount: false,
    value: (row) => Catalogs.tiposComprobante[row.tipoComprobante] ?? '',
  ),
  (title: 'Serie', amount: false, value: (row) => row.serie),
  (title: 'Número', amount: false, value: (row) => row.numero),
  (
    title: 'Tipo doc. cliente',
    amount: false,
    value: (row) => row.clienteTipoDocumento,
  ),
  (
    title: 'Número doc. cliente',
    amount: false,
    value: (row) => row.clienteNumeroDocumento,
  ),
  (title: 'Cliente', amount: false, value: (row) => row.clienteNombre),
  (title: 'Moneda', amount: false, value: (row) => row.moneda),
  (title: 'Exportación', amount: true, value: (row) => row.exportacion),
  (title: 'Gravado', amount: true, value: (row) => row.gravado),
  (title: 'Exonerado', amount: true, value: (row) => row.exonerado),
  (title: 'Inafecto', amount: true, value: (row) => row.inafecto),
  (title: 'ISC', amount: true, value: (row) => row.isc),
  (title: 'IGV', amount: true, value: (row) => row.igv),
  (title: 'ICBPER', amount: true, value: (row) => row.icb),
  (title: 'Total', amount: true, value: (row) => row.total),
  (title: 'Estado', amount: false, value: (row) => row.status.label),
  (title: 'Modifica a', amount: false, value: (row) => row.modifica ?? ''),
];

/// The register as CSV (UTF-8 with BOM, so Excel reads the accents)
Uint8List salesCsv(List<SalesRow> rows) {
  String field(Object value, {bool amount = false}) {
    var text = '$value';
    // A name like "=HYPERLINK(...)" would run as a formula in Excel
    if (!amount && RegExp(r'^[=+\-@\t\r]').hasMatch(text)) text = "'$text";
    return RegExp(r'[",\r\n]').hasMatch(text)
        ? '"${text.replaceAll('"', '""')}"'
        : text;
  }

  final lines = [
    _columns.map((column) => field(column.title)).join(','),
    for (final row in rows)
      _columns
          .map((column) => field(column.value(row), amount: column.amount))
          .join(','),
  ];
  return Uint8List.fromList([
    0xef, 0xbb, 0xbf, // BOM
    ...utf8.encode('${lines.join('\r\n')}\r\n'),
  ]);
}

/// The register as an Excel workbook (.xlsx), amounts as numbers
Uint8List salesXlsx(List<SalesRow> rows) {
  String escape(String text) => text
      // Characters XML 1.0 forbids would make the file "corrupt"
      .replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '')
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
  // Style 1: amounts with two decimals (built-in format 4, #,##0.00)
  String cell(Object value, {required bool number}) => number
      ? '<c s="1"><v>$value</v></c>'
      : '<c t="inlineStr"><is><t xml:space="preserve">${escape('$value')}</t></is></c>';
  String sheetRow(Iterable<String> cells) => '<row>${cells.join()}</row>';

  final sheet =
      StringBuffer(
          '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
          '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
          '<sheetData>',
        )
        ..write(sheetRow(_columns.map((c) => cell(c.title, number: false))))
        ..writeAll([
          for (final row in rows)
            sheetRow(
              _columns.map(
                (column) => cell(column.value(row), number: column.amount),
              ),
            ),
        ])
        ..write('</sheetData></worksheet>');

  final archive = Archive()
    ..add(
      ArchiveFile.string(
        '[Content_Types].xml',
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
            '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
            '<Default Extension="xml" ContentType="application/xml"/>'
            '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
            '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
            '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
            '</Types>',
      ),
    )
    ..add(
      ArchiveFile.string(
        '_rels/.rels',
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
            '</Relationships>',
      ),
    )
    ..add(
      ArchiveFile.string(
        'xl/workbook.xml',
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
            'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
            '<sheets><sheet name="Ventas" sheetId="1" r:id="rId1"/></sheets>'
            '</workbook>',
      ),
    )
    ..add(
      ArchiveFile.string(
        'xl/_rels/workbook.xml.rels',
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
            '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>'
            '</Relationships>',
      ),
    )
    ..add(
      ArchiveFile.string(
        'xl/styles.xml',
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
            '<fonts count="1"><font><sz val="11"/><name val="Calibri"/></font></fonts>'
            '<fills count="2"><fill><patternFill patternType="none"/></fill>'
            '<fill><patternFill patternType="gray125"/></fill></fills>'
            '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>'
            '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'
            '<cellXfs count="2"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>'
            '<xf numFmtId="4" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/></cellXfs>'
            '</styleSheet>',
      ),
    )
    ..add(ArchiveFile.string('xl/worksheets/sheet1.xml', sheet.toString()));
  return ZipEncoder().encodeBytes(archive);
}

/// Totals of [rows] in one currency
class SalesSummary {
  SalesSummary(this.moneda, Iterable<SalesRow> rows)
    : count = rows.length,
      voided = rows.where((row) => row.voided).length,
      unconfirmed = rows.where((row) => row.unconfirmed).length,
      gravado = _sum(rows, (row) => row.gravado),
      igv = _sum(rows, (row) => row.igv),
      total = _sum(rows, (row) => row.total);

  final String moneda;
  final int count;
  final int voided;

  /// Waiting for SUNAT's answer: the month may still change
  final int unconfirmed;
  final String gravado;
  final String igv;
  final String total;

  static String _sum(Iterable<SalesRow> rows, String Function(SalesRow) of) =>
      fromCents(rows.fold(BigInt.zero, (sum, row) => sum + toCents(of(row))));
}

/// One summary per currency, PEN first
List<SalesSummary> salesSummaries(List<SalesRow> rows) {
  final monedas = {for (final row in rows) row.moneda}.toList()
    ..sort((a, b) => a == 'PEN' ? -1 : (b == 'PEN' ? 1 : a.compareTo(b)));
  return [
    for (final moneda in monedas)
      SalesSummary(moneda, rows.where((row) => row.moneda == moneda)),
  ];
}
