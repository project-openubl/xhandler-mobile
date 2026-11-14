import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'document_view.dart';

/// A way to print documents; adding one = a class in [pdfTemplates]
/// (docs/DESIGN.md §7.1)
abstract interface class PdfTemplate {
  /// "default-a4", "default-ticket-80"...
  String get id;

  /// Shown to the user
  String get name;
  Future<Uint8List> render(DocumentView view, pw.ThemeData theme);
}

/// Open Sans, so any name prints (the PDF base fonts only cover Latin-1)
Future<pw.ThemeData> loadPdfTheme() async {
  Future<pw.Font> font(String name) async =>
      pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-$name.ttf'));
  return pw.ThemeData.withFont(
    base: await font('Regular'),
    bold: await font('Bold'),
  );
}

const pdfTemplates = <PdfTemplate>[
  A4Template(),
  TicketTemplate(widthMm: 80),
  TicketTemplate(widthMm: 58),
];

const _pendingNote =
    'PENDIENTE DE ENVÍO A SUNAT: este documento aún no fue recibido por SUNAT.';

pw.Widget _qr(String data, double size) => pw.BarcodeWidget(
  barcode: pw.Barcode.qrCode(),
  data: data,
  drawText: false,
  width: size,
  height: size,
);

/// Label and value rows
pw.Widget _rows(
  List<(String, String)> rows, {
  pw.TextStyle? style,
  bool alignRight = false,
}) => pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
  children: [
    for (final (label, value) in rows)
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: alignRight
            ? pw.MainAxisAlignment.end
            : pw.MainAxisAlignment.start,
        children: [
          pw.Text(
            '$label: ',
            style: style?.copyWith(fontWeight: pw.FontWeight.bold),
          ),
          alignRight
              ? pw.Text(value, style: style)
              : pw.Expanded(child: pw.Text(value, style: style)),
        ],
      ),
  ],
);

/// A4 page with the company box, lines table and totals
class A4Template implements PdfTemplate {
  const A4Template();

  @override
  String get id => 'default-a4';

  @override
  String get name => 'A4';

  @override
  Future<Uint8List> render(DocumentView view, pw.ThemeData theme) {
    const small = pw.TextStyle(fontSize: 9);
    final bold = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
    final document = pw.Document(
      title: '${view.title} ${view.serieNumero}',
      theme: theme,
    );
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (_) => pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    view.companyCommercialName ?? view.companyName,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  if (view.companyCommercialName != null)
                    pw.Text(view.companyName, style: small),
                  if (view.companyAddress case final address?)
                    pw.Text(address, style: small),
                ],
              ),
            ),
            pw.Container(
              width: 200,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                children: [
                  pw.Text('RUC ${view.ruc}', style: bold),
                  pw.Text(
                    view.title,
                    style: bold,
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(view.serieNumero, style: bold),
                ],
              ),
            ),
          ],
        ),
        footer: (context) => pw.Column(
          children: [
            pw.Text(view.footer, style: const pw.TextStyle(fontSize: 7)),
            pw.Text(
              '${context.pageNumber}/${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 7),
            ),
          ],
        ),
        build: (_) => [
          pw.SizedBox(height: 16),
          if (view.pending)
            pw.Container(
              padding: const pw.EdgeInsets.all(6),
              margin: const pw.EdgeInsets.only(bottom: 8),
              color: PdfColors.amber100,
              child: pw.Text(_pendingNote, style: bold),
            ),
          _rows([
            ('Fecha de emisión', view.fechaEmision),
            ...view.header,
          ], style: small),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
            headerStyle: bold,
            cellStyle: small,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            cellAlignments: {
              0: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            columnWidths: {2: const pw.FlexColumnWidth(4)},
            headers: [
              'Cant.',
              'Unidad',
              'Descripción',
              if (view.showPrices) ...['P. unit.', 'Importe'],
            ],
            data: [
              for (final line in view.lines)
                [
                  line.cantidad,
                  line.unidad,
                  line.descripcion,
                  if (view.showPrices) ...[
                    line.precio ?? '',
                    line.importe ?? '',
                  ],
                ],
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (view.amountInWords case final words?)
                      pw.Text(words, style: bold),
                    for (final note in view.notes) pw.Text(note, style: small),
                    if (view.qr case final qr?) ...[
                      pw.SizedBox(height: 8),
                      _qr(qr, 90),
                    ],
                  ],
                ),
              ),
              if (view.total != null)
                pw.SizedBox(
                  width: 200,
                  child: _rows(
                    [...view.totals, ('TOTAL', view.total!)],
                    style: small,
                    alignRight: true,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
    return document.save();
  }
}

/// A roll of thermal paper, [widthMm] wide, everything in one column
class TicketTemplate implements PdfTemplate {
  const TicketTemplate({required this.widthMm});

  final int widthMm;

  @override
  String get id => 'default-ticket-$widthMm';

  @override
  String get name => 'Ticket $widthMm mm';

  @override
  Future<Uint8List> render(DocumentView view, pw.ThemeData theme) {
    final size = widthMm >= 80 ? 8.0 : 7.0;
    final small = pw.TextStyle(fontSize: size);
    final bold = small.copyWith(fontWeight: pw.FontWeight.bold);
    final center = pw.CrossAxisAlignment.center;
    final document = pw.Document(
      title: '${view.title} ${view.serieNumero}',
      theme: theme,
    );
    document.addPage(
      pw.Page(
        // As long as its contents
        pageFormat: PdfPageFormat(
          widthMm * PdfPageFormat.mm,
          double.infinity,
          marginAll: 3 * PdfPageFormat.mm,
        ),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Column(
              crossAxisAlignment: center,
              children: [
                pw.Text(
                  view.companyCommercialName ?? view.companyName,
                  style: bold.copyWith(fontSize: size + 2),
                  textAlign: pw.TextAlign.center,
                ),
                if (view.companyCommercialName != null)
                  pw.Text(view.companyName, style: small),
                pw.Text('RUC ${view.ruc}', style: small),
                if (view.companyAddress case final address?)
                  pw.Text(
                    address,
                    style: small,
                    textAlign: pw.TextAlign.center,
                  ),
                pw.SizedBox(height: 4),
                pw.Text(
                  view.title,
                  style: bold,
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(view.serieNumero, style: bold),
              ],
            ),
            if (view.pending)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Text(_pendingNote, style: bold),
              ),
            pw.Divider(thickness: 0.5),
            _rows([('Fecha', view.fechaEmision), ...view.header], style: small),
            pw.Divider(thickness: 0.5),
            for (final line in view.lines) ...[
              pw.Text(line.descripcion, style: small),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '${line.cantidad} ${line.unidad}'
                    '${line.precio == null ? '' : ' x ${line.precio}'}',
                    style: small,
                  ),
                  if (line.importe case final importe?)
                    pw.Text(importe, style: small),
                ],
              ),
            ],
            pw.Divider(thickness: 0.5),
            if (view.total != null)
              _rows(
                [...view.totals, ('TOTAL', view.total!)],
                style: small,
                alignRight: true,
              ),
            if (view.amountInWords case final words?)
              pw.Text(words, style: small),
            for (final note in view.notes) pw.Text(note, style: small),
            if (view.qr case final qr?)
              pw.Center(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: _qr(qr, widthMm >= 80 ? 110 : 90),
                ),
              ),
            pw.Text(
              view.footer,
              style: small.copyWith(fontSize: size - 1),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
    );
    return document.save();
  }
}
