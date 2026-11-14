import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/providers.dart';
import 'package:xhandler_mobile/features/document/document_detail_page.dart';
import 'package:xhandler_mobile/features/document/document_repository.dart';
import 'package:xhandler_mobile/features/document/document_service.dart';
import 'package:xhandler_mobile/features/document/document_status.dart';
import 'package:xhandler_mobile/features/document/documents_list.dart';
import 'package:xhandler_mobile/features/document/invoice_draft.dart';
import 'package:xhandler_mobile/features/document/invoice_form_page.dart';
import 'package:xhandler_mobile/features/document/sunat_bridge.dart';
import 'package:xhandler_mobile/src/rust/api/error.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';
import 'package:xhandler_mobile/strings.dart';

import '../fake_bridge.dart';
import '../helpers.dart';

const _accepted = SunatResponse(
  status: SunatStatus.accepted,
  code: '0',
  notes: [],
);

const _boleta = InvoiceDraft(
  tipoComprobante: '03',
  moneda: 'PEN',
  customer: anonymousCustomer,
  lines: [DraftLine(descripcion: 'x', cantidad: '1', precio: '10')],
);

void main() {
  DocumentService serviceFor(TestData data, FakeBridge bridge) =>
      DocumentService(
        data.database,
        DocumentRepository(data.database),
        data.secureStore,
        bridge,
        demoCertificate: () async => Uint8List(1),
      );

  /// Pumps [page] (pushed over an empty page) with [service] on a fake bridge
  Future<void> pumpPage(
    WidgetTester tester,
    TestData data,
    DocumentService service,
    FakeBridge bridge,
    Widget page,
  ) async {
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(data.database),
          sunatBridgeProvider.overrideWithValue(bridge),
          documentServiceProvider.overrideWithValue(service),
        ],
        child: MaterialApp(navigatorKey: navigator, home: const Scaffold()),
      ),
    );
    navigator.currentState!.push(MaterialPageRoute<void>(builder: (_) => page));
  }

  /// Pumps frames, letting the database and the bridge work in real time,
  /// until [done] (spinners never settle, so no pumpAndSettle)
  Future<void> pumpUntil(
    WidgetTester tester,
    bool Function() done, [
    String step = '',
  ]) async {
    for (var i = 0; i < 100; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      if (done()) return;
    }
    fail('The expected state never came $step');
  }

  bool shows(String text) => find.text(text).evaluate().isNotEmpty;

  Future<Serie> serie(WidgetTester tester, TestData data, String serie) async =>
      (await tester.runAsync(
        () => (data.database.select(
          data.database.series,
        )..where((s) => s.serie.equals(serie))).getSingle(),
      ))!;

  Future<void> addFreeLine(WidgetTester tester, String precio) async {
    await tester.tap(find.text(Strings.freeLine));
    await pumpUntil(tester, () => shows(Strings.add));
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.descripcion),
      'Café',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.precio),
      precio,
    );
    await tester.tap(find.text(Strings.add));
  }

  group('InvoiceFormPage', () {
    testWidgets('issues a boleta, shows SUNAT answer and opens it', (
      tester,
    ) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      final bridge = FakeBridge()
        ..total = '59.00'
        ..responses.add(_accepted);
      await pumpPage(
        tester,
        data,
        serviceFor(data, bridge),
        bridge,
        InvoiceFormPage(company!, tipoComprobante: '03'),
      );
      await pumpUntil(tester, () => shows('B001-00000001'));
      expect(find.text('CLIENTES VARIOS'), findsOneWidget); // boleta default

      await addFreeLine(tester, '59');
      await pumpUntil(tester, () => shows('S/ 59.00')); // totals preview

      await tester.tap(find.text(Strings.emit));
      await pumpUntil(tester, () => shows(Strings.viewDocument), 'sheet');
      await tester.pump(const Duration(seconds: 1)); // sheet fully open
      expect(find.text(DocumentStatus.accepted.label), findsOneWidget);

      await tester.tap(find.text(Strings.viewDocument));
      await pumpUntil(
        tester,
        () => find.byType(DocumentDetailPage).evaluate().isNotEmpty,
        'detail',
      );
      await tester.pump(const Duration(seconds: 1)); // transition
      expect(find.byType(InvoiceFormPage), findsNothing); // replaced
      await data.unmount(tester);
    });

    testWidgets('credit needs installments', (tester) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      final bridge = FakeBridge();
      await pumpPage(
        tester,
        data,
        serviceFor(data, bridge),
        bridge,
        InvoiceFormPage(company!, tipoComprobante: '03'),
      );
      await pumpUntil(tester, () => shows('B001-00000001'));
      await addFreeLine(tester, '59');
      await pumpUntil(tester, () => shows('S/ 118.00'));

      // The fake bridge's default total
      await tester.tap(find.text(Strings.credito));
      await pumpUntil(tester, () => shows(Strings.creditoWithoutCuotas));

      final emit = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, Strings.emit),
      );
      expect(emit.onPressed, isNull);
      await data.unmount(tester);
    });

    testWidgets('a document that cannot be built uses no number', (
      tester,
    ) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      final bridge = FakeBridge();
      await pumpPage(
        tester,
        data,
        serviceFor(data, bridge),
        bridge,
        InvoiceFormPage(company!, tipoComprobante: '03'),
      );
      await pumpUntil(tester, () => shows('B001-00000001'));
      await addFreeLine(tester, '10');
      await pumpUntil(tester, () => shows('S/ 118.00'));

      bridge.buildError = const BridgeError(
        kind: BridgeErrorKind.invalidDocument,
        message: 'detalles[0].igv_tipo: 99 is not a valid Catalog7',
      );
      await tester.tap(find.text(Strings.emit));
      await pumpUntil(
        tester,
        () => shows('Un código no es válido: tipo de IGV (línea 1).'),
      );

      final documents = (await tester.runAsync(
        () => data.database.select(data.database.documents).get(),
      ))!;
      expect(documents, isEmpty);
      await data.unmount(tester);
    });
  });

  testWidgets('DocumentDetailPage sends again and shows the new status', (
    tester,
  ) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final b001 = await serie(tester, data, 'B001');
    final id = (await tester.runAsync(
      () => service.emit(company: company!, serie: b001, draft: _boleta),
    ))!;
    await tester.runAsync(
      () =>
          (data.database.update(
            data.database.documents,
          )..where((d) => d.id.equals(id))).write(
            const DocumentsCompanion(
              status: Value(DocumentStatus.exception),
              sunatCode: Value(LocalCodes.noCredentials),
            ),
          ),
    );

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      DocumentDetailPage(documentId: id),
    );
    await pumpUntil(tester, () => shows(DocumentStatus.exception.label));
    expect(find.textContaining('credenciales SOL'), findsWidgets);
    expect(find.textContaining('NO_CREDENTIALS'), findsNothing);

    bridge.responses.add(_accepted);
    await tester.tap(find.text(DocumentStatus.exception.actionLabel!));
    await pumpUntil(tester, () => shows(DocumentStatus.accepted.help));
    await data.unmount(tester);
  });

  testWidgets('DocumentsList filters by status', (tester) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final b001 = await serie(tester, data, 'B001');
    await tester.runAsync(() async {
      await service.emit(company: company!, serie: b001, draft: _boleta);
      final accepted = await service.emit(
        company: company,
        serie: b001,
        draft: _boleta,
      );
      bridge.responses.add(_accepted);
      await service.send(accepted);
    });

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      Scaffold(body: DocumentsList(company!)),
    );
    await pumpUntil(
      tester,
      () => find.textContaining('B001-').evaluate().length == 2,
    );

    await tester.tap(find.text(Strings.acceptedDocuments));
    await pumpUntil(
      tester,
      () =>
          find.textContaining('B001-00000001').evaluate().isEmpty &&
          find.textContaining('B001-00000002').evaluate().isNotEmpty,
    );
    await data.unmount(tester);
  });

  test('overlapping outbox rounds send once', () async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final company = await data.createCompany();
    final b001 = await (data.database.select(
      data.database.series,
    )..where((s) => s.serie.equals('B001'))).getSingle();
    await service.emit(company: company, serie: b001, draft: _boleta);
    bridge.responses.add(
      const SunatResponse(status: SunatStatus.notDelivered, notes: []),
    );

    await Future.wait([
      service.sendDue(),
      service.sendDue(),
      service.sendDue(),
    ]);

    expect(bridge.calls, hasLength(1));
  });

  test('a catalog line keeps its product data', () async {
    const line = DraftLine(
      descripcion: 'Cerveza',
      cantidad: '1',
      precio: '7.50',
      codigo: 'CER-01',
      iscTipo: '01',
      iscTasa: '30',
    );
    final edited = line.copyWith(cantidad: '6');
    final json = jsonDecode(jsonEncode(edited.toJson())) as Map;
    expect(json['cantidad'], '6');
    expect(json['codigo'], 'CER-01');
    expect(json['isc_tasa'], '0.30');
  });
}
