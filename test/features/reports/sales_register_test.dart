import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/document/document_repository.dart';
import 'package:xhandler_mobile/features/reports/sales_register.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

/// A real enriched factura: gravado 29.42, ISC 8.80, IGV 6.88, ICBPER 0.50
final _enriched = File('test/resources/enriched_factura.json')
    .readAsStringSync();

Document _document({
  String id = 'f1',
  String tipo = '01',
  String serie = 'F001',
  int numero = 1,
  String fecha = '2026-11-13',
  String moneda = 'PEN',
  DocumentStatus status = DocumentStatus.accepted,
  String? enriched,
  String nombre = 'SUPERMERCADOS PERUANOS S.A.',
}) => Document(
  id: id,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  companyId: 'c1',
  environment: SunatEnvironment.beta,
  tipoComprobante: tipo,
  serie: serie,
  numero: numero,
  fechaEmision: fecha,
  clienteTipoDocumento: '6',
  clienteNumeroDocumento: '20100070970',
  clienteNombre: nombre,
  moneda: moneda,
  total: '45.60',
  status: status,
  digestValue: 'hash',
  attempts: 0,
  inputJson: '{}',
  enrichedJson: enriched ?? _enriched,
  deviceId: 'd',
);

void main() {
  test('a factura lists its taxes; a nota de crédito subtracts', () {
    final factura = SalesRow.of(_document());
    expect(factura.gravado, '29.42');
    expect(factura.isc, '8.80');
    expect(factura.igv, '6.88');
    expect(factura.icb, '0.50');
    expect(factura.total, '45.60');
    expect(factura.exonerado, '0.00');

    final spec = (jsonDecode(_enriched) as Map)['spec'] as Map
      ..['comprobante_afectado_tipo'] = '01'
      ..['comprobante_afectado_serie_numero'] = 'F001-1';
    final nota = SalesRow.of(
      _document(
        tipo: '07',
        serie: 'FC01',
        enriched: jsonEncode({'spec': spec}),
      ),
    );
    expect(nota.igv, '-6.88');
    expect(nota.total, '-45.60');
    expect(nota.exonerado, '0.00'); // not -0.00
    expect(nota.modifica, '01 F001-1');
  });

  test('voided documents are listed without amounts', () {
    final row = SalesRow.of(_document(status: DocumentStatus.voided));
    expect(row.voided, isTrue);
    expect(row.total, '0.00');
    expect(row.igv, '0.00');
  });

  test('summaries per currency, notas subtracting', () {
    final spec = (jsonDecode(_enriched) as Map)['spec'] as Map;
    final rows = [
      SalesRow.of(_document()),
      SalesRow.of(
        _document(id: 'n', tipo: '07', enriched: jsonEncode({'spec': spec})),
      ),
      SalesRow.of(_document(id: 'f2', numero: 2)),
      SalesRow.of(_document(id: 'v', numero: 3, status: DocumentStatus.voided)),
      SalesRow.of(_document(id: 'u', numero: 4, moneda: 'USD')),
    ];
    final [pen, usd] = salesSummaries(rows);
    expect(pen.moneda, 'PEN');
    expect(pen.count, 4);
    expect(pen.voided, 1);
    expect(pen.unconfirmed, 0);
    expect(pen.total, '45.60'); // 45.60 − 45.60 + 45.60 + 0
    expect(usd.total, '45.60');
  });

  test('unconfirmed documents are counted apart', () {
    final [summary] = salesSummaries([
      SalesRow.of(_document()),
      SalesRow.of(_document(id: 'p', status: DocumentStatus.pendingSend)),
      SalesRow.of(_document(id: 'v', status: DocumentStatus.voiding)),
    ]);
    expect(summary.unconfirmed, 2);
    expect(summary.total, '136.80'); // they are issued sales
  });

  test('CSV text never runs as a formula; amounts keep their sign', () {
    final spec = (jsonDecode(_enriched) as Map)['spec'] as Map;
    final lines = utf8
        .decode(
          salesCsv([
            SalesRow.of(_document(nombre: '=1+1')),
            SalesRow.of(
              _document(tipo: '07', enriched: jsonEncode({'spec': spec})),
            ),
          ]).sublist(3),
        )
        .split('\r\n');
    expect(lines[1], contains(",'=1+1,"));
    expect(lines[2], contains(',-6.88,'));
  });

  test('CSV with a BOM, quoting what needs it', () {
    final csv = salesCsv([
      SalesRow.of(_document(nombre: 'Pérez, "El Bueno" S.A.C.')),
    ]);
    expect(csv.take(3), [0xef, 0xbb, 0xbf]);
    final lines = utf8.decode(csv.sublist(3)).split('\r\n');
    expect(lines.first, startsWith('Fecha,Tipo,Comprobante,Serie,Número'));
    expect(lines[1], contains('"Pérez, ""El Bueno"" S.A.C."'));
    expect(lines[1], contains(',29.42,'));
  });

  test('an Excel workbook with numbers and escaped text', () {
    final xlsx = salesXlsx([SalesRow.of(_document(nombre: 'A & B <S.A.>'))]);
    final files = {
      for (final file in ZipDecoder().decodeBytes(xlsx))
        file.name: utf8.decode(file.content as List<int>),
    };
    expect(
      files.keys,
      containsAll([
        '[Content_Types].xml',
        '_rels/.rels',
        'xl/workbook.xml',
        'xl/_rels/workbook.xml.rels',
        'xl/worksheets/sheet1.xml',
      ]),
    );
    if (Platform.environment['XLSX_SAMPLE'] case final path?) {
      File(path).writeAsBytesSync(xlsx);
    }
    final sheet = files['xl/worksheets/sheet1.xml']!;
    expect(sheet, contains('<c s="1"><v>29.42</v></c>'));
    expect(files['xl/styles.xml'], contains('numFmtId="4"'));
    expect(sheet, contains('A &amp; B &lt;S.A.&gt;'));
  });

  test(
    'the register takes the month\'s accepted and voided documents',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await database
          .into(database.companies)
          .insert(
            CompaniesCompanion.insert(
              id: const Value('c1'),
              ruc: '20123456789',
              razonSocial: 'E',
            ),
          );
      for (final document in [
        _document(id: 'a', numero: 1),
        _document(
          id: 'b',
          numero: 2,
          fecha: '2026-11-30',
          status: DocumentStatus.voided,
        ),
        _document(id: 'c', numero: 3, status: DocumentStatus.rejected),
        _document(id: 'd', numero: 4, status: DocumentStatus.pendingSend),
        _document(id: 'e', numero: 5, fecha: '2026-12-01'),
        _document(id: 'g', tipo: '09', serie: 'T001'),
        _document(id: 'h', numero: 6, status: DocumentStatus.voiding),
        _document(
          id: 'i',
          numero: 7,
        ).copyWith(environment: SunatEnvironment.production),
        _document(
          id: 'j',
          numero: 8,
        ).copyWith(deletedAt: Value(DateTime.utc(2026))),
      ]) {
        await database
            .into(database.documents)
            .insert(document.toCompanion(false));
      }

      final issued = await DocumentRepository(database).issued(
        'c1',
        SunatEnvironment.beta,
        from: '2026-11-01',
        to: '2026-11-30',
        tipos: salesTipos,
        statuses: salesStatuses,
      );
      // Not rejected, other months, guías, production or deleted ones
      expect(
        [for (final document in issued) document.id],
        ['a', 'd', 'h', 'b'],
      );
    },
  );
}
