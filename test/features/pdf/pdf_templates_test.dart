import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/document/document_repository.dart';
import 'package:xhandler_mobile/features/pdf/document_view.dart';
import 'package:xhandler_mobile/features/pdf/share_document.dart';
import 'package:xhandler_mobile/features/pdf/pdf_templates.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

final _company = Company(
  id: '1',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  ruc: '20123456789',
  razonSocial: 'Empresa S.A.C.',
  nombreComercial: 'Empresa',
  direccion: 'AV. LARCO 123',
  distrito: 'MIRAFLORES',
  provincia: 'LIMA',
  departamento: 'LIMA',
  sunatEnvironment: SunatEnvironment.beta,
  moneda: 'PEN',
  igvTipo: '10',
  esAgentePercepcion: false,
  esAgenteRetencion: false,
  lookupProvider: LookupProvider.none,
);

Document _document(String tipo, String serie, String json, String total) =>
    Document(
      id: tipo,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      companyId: '1',
      environment: SunatEnvironment.beta,
      tipoComprobante: tipo,
      serie: serie,
      numero: 1,
      fechaEmision: '2026-11-13',
      clienteTipoDocumento: '6',
      clienteNumeroDocumento: '20100070970',
      clienteNombre: 'SUPERMERCADOS PERUANOS S.A.',
      moneda: 'PEN',
      total: total,
      status: DocumentStatus.accepted,
      digestValue: 'abc123=',
      attempts: 0,
      inputJson: json,
      enrichedJson: json,
      deviceId: 'd',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final factura = _document(
    '01',
    'F001',
    File('test/resources/enriched_factura.json').readAsStringSync(),
    '45.60',
  );

  test('a factura prints its lines, taxes, words and QR', () {
    final view = documentView(factura, _company);

    expect(view.title, 'FACTURA ELECTRÓNICA');
    expect(view.serieNumero, 'F001-00000001');
    expect(view.lines.first.importe, 'S/ 45.00'); // 6 × 7.50
    expect(view.lines.last.importe, 'S/ 0.60'); // bag: 0.10 + ICBPER 0.50
    expect(view.totals, contains(('IGV', 'S/ 6.88')));
    expect(view.amountInWords, 'SON: CUARENTA Y CINCO CON 60/100 SOLES');
    expect(
      view.qr,
      '20123456789|01|F001|1|6.88|45.60|2026-11-13|6|20100070970|abc123=|',
    );
    expect(view.pending, isFalse);
    expect(
      documentView(
        factura.copyWith(status: DocumentStatus.pendingSend),
        _company,
      ).pending,
      isTrue,
    );
  });

  test('every template renders every printable document', () async {
    final theme = await loadPdfTheme();
    String draft(String name) =>
        File('rust/tests/resources/drafts/$name.json').readAsStringSync();
    final documents = [
      factura,
      _document('40', 'P001', draft('percepcion'), '23.60'),
      _document('20', 'R001', draft('retencion'), '15.02'),
      _document('09', 'T001', draft('guia_transporte_privado'), '0.00'),
      _document('09', 'T001', draft('guia_transporte_publico'), '0.00'),
    ];
    for (final document in documents) {
      final view = documentView(document, _company);
      for (final template in pdfTemplates) {
        final pdf = await template.render(view, theme);
        if (Platform.environment['PDF_SAMPLES'] case final dir?) {
          File('$dir/${document.serie}-${template.id}.pdf')
              .writeAsBytesSync(pdf);
        }
        expect(
          String.fromCharCodes(pdf.take(4)),
          '%PDF',
          reason: '${template.id} ${document.tipoComprobante}',
        );
      }
    }
  });

  test('files are named as SUNAT names them', () {
    expect(sunatFileName(_company, factura), '20123456789-01-F001-1');
  });

  test('the customer gets the PDF, the signed XML and the CDR', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.into(database.companies).insert(_company.toCompanion(false));
    await database.into(database.documents).insert(factura.toCompanion(false));
    for (final (kind, bytes) in [
      (DocumentFileKind.signedXml, [60]),
      (DocumentFileKind.cdrZip, [80, 75]),
    ]) {
      await database
          .into(database.documentFiles)
          .insert(
            DocumentFilesCompanion.insert(
              documentId: factura.id,
              kind: kind,
              bytes: Uint8List.fromList(bytes),
              sha256: 'x',
            ),
          );
    }

    final files = await deliveryFiles(
      company: _company,
      document: factura,
      documents: DocumentRepository(database),
      template: pdfTemplates.first,
    );

    expect(
      [for (final file in files) file.name],
      [
        '20123456789-01-F001-1.pdf',
        '20123456789-01-F001-1.xml',
        'R-20123456789-01-F001-1.zip',
      ],
    );
  });
}
