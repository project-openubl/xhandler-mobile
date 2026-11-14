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
import 'package:xhandler_mobile/src/rust/api/sunat.dart';
import 'package:xhandler_mobile/strings.dart';

import '../fake_bridge.dart';
import '../helpers.dart';

void main() {
  /// Pumps [page] with a DocumentService on [bridge] instead of Rust
  Future<DocumentService> pumpWithBridge(
    WidgetTester tester,
    TestData data,
    FakeBridge bridge,
    Widget page,
  ) async {
    final service = DocumentService(
      data.database,
      DocumentRepository(data.database),
      data.secureStore,
      bridge,
      demoCertificate: () async => Uint8List(1),
    );
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
    return service;
  }

  /// Lets the database and the totals preview work
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
    // No pumpAndSettle: loading spinners never settle
  }

  testWidgets('InvoiceFormPage issues a boleta and shows SUNAT answer', (
    tester,
  ) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    final bridge = FakeBridge()..total = '59.00';
    bridge.responses.add(
      const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
    );
    await pumpWithBridge(
      tester,
      data,
      bridge,
      InvoiceFormPage(company!, tipoComprobante: '03'),
    );
    await settle(tester);

    expect(find.text('B001-00000001'), findsOneWidget);
    expect(find.text('CLIENTES VARIOS'), findsOneWidget); // boleta default

    await tester.tap(find.text(Strings.freeLine));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.descripcion),
      'Café',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.precio),
      '59',
    );
    await tester.tap(find.text(Strings.add));
    await settle(tester);

    expect(find.text('PEN 59.00'), findsOneWidget); // totals preview

    await tester.tap(find.text(Strings.emit));
    await settle(tester);

    expect(find.text(DocumentStatus.accepted.label), findsOneWidget);
    final documents = (await tester.runAsync(
      () => data.database.select(data.database.documents).get(),
    ))!;
    expect(documents.single.status, DocumentStatus.accepted);
    expect(documents.single.serie, 'B001');
    await data.unmount(tester);
  });

  testWidgets(
    'DocumentDetailPage offers to send again a document SUNAT did not process',
    (tester) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      final bridge = FakeBridge();
      final service = DocumentService(
        data.database,
        DocumentRepository(data.database),
        data.secureStore,
        bridge,
        demoCertificate: () async => Uint8List(1),
      );
      final b001 = (await tester.runAsync(
        () => (data.database.select(
          data.database.series,
        )..where((s) => s.serie.equals('B001'))).getSingle(),
      ))!;
      final id = (await tester.runAsync(
        () => service.emit(
          company: company!,
          serie: b001,
          draft: const InvoiceDraft(
            tipoComprobante: '03',
            moneda: 'PEN',
            customer: anonymousCustomer,
            lines: [DraftLine(descripcion: 'x', cantidad: '1', precio: '10')],
          ),
        ),
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

      await pumpWithBridge(
        tester,
        data,
        bridge,
        DocumentDetailPage(documentId: id),
      );
      await settle(tester);

      expect(find.text(DocumentStatus.exception.label), findsWidgets);
      expect(find.textContaining('credenciales SOL'), findsWidgets);
      expect(find.text(Strings.sendNow), findsOneWidget);
      await data.unmount(tester);
    },
  );

  testWidgets('DocumentsList filters by status', (tester) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    final bridge = FakeBridge();
    final service = DocumentService(
      data.database,
      DocumentRepository(data.database),
      data.secureStore,
      bridge,
      demoCertificate: () async => Uint8List(1),
    );
    final b001 = (await tester.runAsync(
      () => (data.database.select(
        data.database.series,
      )..where((s) => s.serie.equals('B001'))).getSingle(),
    ))!;
    const draft = InvoiceDraft(
      tipoComprobante: '03',
      moneda: 'PEN',
      customer: anonymousCustomer,
      lines: [DraftLine(descripcion: 'x', cantidad: '1', precio: '10')],
    );
    await tester.runAsync(() async {
      await service.emit(company: company!, serie: b001, draft: draft);
      final accepted = await service.emit(
        company: company,
        serie: b001,
        draft: draft,
      );
      bridge.responses.add(
        const SunatResponse(status: SunatStatus.accepted, code: '0', notes: []),
      );
      await service.send(accepted);
    });

    await pumpWithBridge(
      tester,
      data,
      bridge,
      Scaffold(body: DocumentsList(company!)),
    );
    await settle(tester);
    expect(find.textContaining('B001-'), findsNWidgets(2));

    await tester.tap(find.text('Aceptados'));
    await settle(tester);
    expect(find.textContaining('B001-00000002'), findsOneWidget);
    expect(find.textContaining('B001-00000001'), findsNothing);
    await data.unmount(tester);
  });
}
