import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/catalogs.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/providers.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/delivery/email_sender.dart';
import 'package:xhandler_mobile/features/despatch/despatch_advice_form_page.dart';
import 'package:xhandler_mobile/features/document/background_outbox.dart';
import 'package:xhandler_mobile/features/document/document_detail_page.dart';
import 'package:xhandler_mobile/features/document/document_repository.dart';
import 'package:xhandler_mobile/features/document/document_service.dart';
import 'package:xhandler_mobile/features/document/document_status.dart';
import 'package:xhandler_mobile/features/document/documents_list.dart';
import 'package:xhandler_mobile/features/document/draft_problem.dart';
import 'package:xhandler_mobile/features/document/invoice_draft.dart';
import 'package:xhandler_mobile/features/document/invoice_form_page.dart';
import 'package:xhandler_mobile/features/document/note_form_page.dart';
import 'package:xhandler_mobile/features/document/perception_retention_form_page.dart';
import 'package:xhandler_mobile/features/document/quick_sale_page.dart';
import 'package:xhandler_mobile/features/document/sunat_answer.dart';
import 'package:xhandler_mobile/features/document/sunat_bridge.dart';
import 'package:xhandler_mobile/features/product/product_repository.dart';
import 'package:xhandler_mobile/src/rust/api/error.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';
import 'package:xhandler_mobile/strings.dart';

import '../fake_bridge.dart';
import '../fake_email_sender.dart';
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
  late FakeEmailSender emailSender;
  setUp(() => emailSender = FakeEmailSender());

  DocumentService serviceFor(TestData data, FakeBridge bridge) =>
      DocumentService(
        data.database,
        DocumentRepository(data.database),
        data.secureStore,
        bridge,
        demoCertificate: () async => Uint8List(1),
        pauseBetweenSends: Duration.zero,
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
          emailSenderProvider.overrideWithValue(emailSender),
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

  group('QuickSalePage', () {
    Future<Company> withCoffee(WidgetTester tester, TestData data) async =>
        (await tester.runAsync(() async {
          final company = await data.createCompany();
          await ProductRepository(data.database).create(
            ProductsCompanion.insert(
              companyId: company.id,
              descripcion: 'Café',
              precio: '4.00',
              favorito: const Value(true),
            ),
          );
          return company;
        }))!;

    testWidgets('sells favorites and starts a new sale', (tester) async {
      final data = TestData();
      final company = await withCoffee(tester, data);
      final bridge = FakeBridge()
        ..total = '8.00'
        ..responses.add(_accepted);
      await pumpPage(
        tester,
        data,
        serviceFor(data, bridge),
        bridge,
        QuickSalePage(company),
      );
      await pumpUntil(tester, () => shows('Café'));

      await tester.tap(find.text('Café'));
      await tester.pump();
      await tester.tap(find.text('Café').first);
      await pumpUntil(tester, () => shows('${Strings.charge} S/ 8.00'));
      expect(find.text('2'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, Strings.received),
        '10',
      );
      await tester.pump();
      expect(find.text('${Strings.change}: S/ 2.00'), findsOneWidget);

      await tester.tap(find.text('${Strings.charge} S/ 8.00'));
      await pumpUntil(tester, () => shows(Strings.newSale), 'sheet');
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.text(Strings.newSale));
      await pumpUntil(tester, () => shows(Strings.cartEmpty), 'cleared');

      final documents = (await tester.runAsync(
        () => data.database.select(data.database.documents).get(),
      ))!;
      expect(documents.single.clienteNombre, 'CLIENTES VARIOS');
      expect(documents.single.status, DocumentStatus.accepted);

      // Nothing left to lose after charging: back just leaves
      await tester.binding.handlePopRoute();
      await pumpUntil(
        tester,
        () => find.byType(QuickSalePage).evaluate().isEmpty,
        'left without asking',
      );
      expect(find.text(Strings.discardChanges), findsNothing);
      await data.unmount(tester);
    });

    testWidgets('asks before losing a cart', (tester) async {
      final data = TestData();
      final company = await withCoffee(tester, data);
      final bridge = FakeBridge()..total = '4.00';
      await pumpPage(
        tester,
        data,
        serviceFor(data, bridge),
        bridge,
        QuickSalePage(company),
      );
      await pumpUntil(tester, () => shows('Café'));
      await tester.tap(find.text('Café'));
      await tester.pump();

      await tester.binding.handlePopRoute();
      await pumpUntil(tester, () => shows(Strings.discardChanges));
      expect(find.byType(QuickSalePage), findsOneWidget);
      await data.unmount(tester);
    });

    testWidgets('− removes products; no boleta serie, no charge', (
      tester,
    ) async {
      final data = TestData();
      final company = await withCoffee(tester, data);
      await tester.runAsync(
        () => data.database
            .update(data.database.series)
            .write(const SeriesCompanion(active: Value(false))),
      );
      final bridge = FakeBridge();
      await pumpPage(
        tester,
        data,
        serviceFor(data, bridge),
        bridge,
        QuickSalePage(company),
      );
      await pumpUntil(tester, () => shows('Café'));
      expect(find.textContaining('No tienes una serie activa'), findsOneWidget);

      await tester.tap(find.text('Café'));
      await pumpUntil(tester, () => shows('1'));
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      await tester.tap(find.byTooltip(Strings.removeOne));
      await pumpUntil(tester, () => shows(Strings.cartEmpty));
      await data.unmount(tester);
    });

    testWidgets('over S/ 700 the customer must be identified', (tester) async {
      final data = TestData();
      final company = await withCoffee(tester, data);
      final bridge = FakeBridge()..total = '704.00';
      await pumpPage(
        tester,
        data,
        serviceFor(data, bridge),
        bridge,
        QuickSalePage(company),
      );
      await pumpUntil(tester, () => shows('Café'));
      await tester.tap(find.text('Café'));
      await pumpUntil(
        tester,
        () => shows(draftProblemMessage(DraftProblem.anonymousOver700)),
      );

      final charge = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(charge.onPressed, isNull);
      await data.unmount(tester);
    });
  });

  /// A factura SUNAT accepted
  Future<Document> acceptedFactura(
    WidgetTester tester,
    TestData data,
    DocumentService service,
    FakeBridge bridge,
  ) async {
    final company = (await tester.runAsync(data.createCompany))!;
    final f001 = await serie(tester, data, 'F001');
    return (await tester.runAsync(() async {
      final id = await service.emit(
        company: company,
        serie: f001,
        draft: const InvoiceDraft(
          tipoComprobante: '01',
          moneda: 'PEN',
          customer: DraftCustomer(
            tipoDocumentoIdentidad: '6',
            numeroDocumentoIdentidad: '20100070970',
            nombre: 'SUPERMERCADOS PERUANOS',
          ),
          lines: [DraftLine(descripcion: 'Café', cantidad: '2', precio: '59')],
        ),
      );
      bridge.responses.add(_accepted);
      await service.send(id);
      return DocumentRepository(data.database).find(id);
    }))!;
  }

  testWidgets('a nota de crédito copies the factura and is issued with FC01', (
    tester,
  ) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      DocumentDetailPage(documentId: factura.id),
    );
    await pumpUntil(tester, () => shows(Strings.notaCredito));
    await tester.tap(find.text(Strings.notaCredito));
    await pumpUntil(
      tester,
      () => find.byType(NoteFormPage).evaluate().isNotEmpty,
    );
    await pumpUntil(tester, () => shows('FC01-00000001'));
    expect(find.text('Café'), findsOneWidget); // copied from the factura

    bridge.responses.add(_accepted);
    await tester.tap(find.text(Strings.emit));
    await pumpUntil(tester, () => shows(Strings.viewDocument), 'sheet');

    final note = (await tester.runAsync(
      () => (data.database.select(
        data.database.documents,
      )..where((d) => d.serie.equals('FC01'))).getSingle(),
    ))!;
    expect(note.affectedDocumentId, factura.id);
    await data.unmount(tester);
  });

  testWidgets("a nota asks before leaving only once it's edited", (
    tester,
  ) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);
    final company = (await tester.runAsync(
      () => data.companies.watchActive().first,
    ))!;
    Future<void> open() async {
      await pumpPage(
        tester,
        data,
        service,
        bridge,
        NoteFormPage(company, affected: factura, tipoComprobante: '07'),
      );
      // The copy of the factura, its series and totals preview are loaded
      await pumpUntil(tester, () => shows('FC01-00000001'));
      await pumpUntil(tester, () => shows('S/ 118.00'));
    }

    await open();
    await tester.binding.handlePopRoute();
    await pumpUntil(
      tester,
      () => find.byType(NoteFormPage).evaluate().isEmpty,
      'left without asking',
    );
    expect(find.text(Strings.discardChanges), findsNothing);

    await open();
    await tester.enterText(
      find.widgetWithText(TextField, Strings.sustento),
      'Descuento por pronto pago',
    );
    await tester.pump();
    await tester.binding.handlePopRoute();
    await pumpUntil(tester, () => shows(Strings.discardChanges));
    await data.unmount(tester);
  });

  testWidgets('a whole-invoice nota keeps its lines; others can change', (
    tester,
  ) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);
    final company = (await tester.runAsync(
      () => data.database.select(data.database.companies).getSingle(),
    ))!;

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      NoteFormPage(company, affected: factura, tipoComprobante: '07'),
    );
    await pumpUntil(tester, () => shows('FC01-00000001'));
    // Totals without touching anything
    await pumpUntil(tester, () => shows(Strings.total), 'totals');
    // Anulación de la operación: the factura's lines, read-only
    expect(find.text(Strings.freeLine), findsNothing);
    expect(find.byTooltip(Strings.delete), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextField, Strings.sustento),
      'Pedido duplicado',
    );
    await tester.tap(find.text(Catalogs.tiposNotaCredito['01']!));
    await pumpUntil(tester, () => shows(Catalogs.tiposNotaCredito['07']!));
    await tester.tap(find.text(Catalogs.tiposNotaCredito['07']!).last);
    await pumpUntil(tester, () => shows(Strings.freeLine));
    expect(find.byTooltip(Strings.delete), findsOneWidget);
    expect(find.text('Pedido duplicado'), findsOneWidget); // kept
    await data.unmount(tester);
  });

  testWidgets('a nota de débito needs a line', (tester) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);
    final company = (await tester.runAsync(
      () => data.database.select(data.database.companies).getSingle(),
    ))!;

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      NoteFormPage(company, affected: factura, tipoComprobante: '08'),
    );
    await pumpUntil(tester, () => shows('FD01-00000001'));
    final emit = find.ancestor(
      of: find.text(Strings.emit),
      matching: find.byType(FilledButton),
    );
    expect(tester.widget<FilledButton>(emit).onPressed, isNull);

    await addFreeLine(tester, '10');
    await pumpUntil(
      tester,
      () => tester.widget<FilledButton>(emit).onPressed != null,
    );
    await data.unmount(tester);
  });

  testWidgets('a factura is voided from its page', (tester) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      DocumentDetailPage(documentId: factura.id),
    );
    await pumpUntil(tester, () => shows(Strings.voidDocument));
    await tester.tap(find.text(Strings.voidDocument));
    await pumpUntil(tester, () => shows(Strings.voidTitle));
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.motivo),
      'Precio errado',
    );
    // SUNAT beta answers with a ticket, taken as accepted
    bridge.responses.add(
      const SunatResponse(
        status: SunatStatus.inProgress,
        ticket: '123',
        notes: [],
      ),
    );
    await tester.tap(find.text(Strings.voidDocument).last);
    await pumpUntil(tester, () => shows(DocumentStatus.voided.help));
    await pumpUntil(
      tester,
      () => find.textContaining('Anulado por RA-').evaluate().isNotEmpty,
      'link',
    );
    expect(find.text(Strings.voidDocument), findsNothing);
    await data.unmount(tester);
  });

  testWidgets('a retención withholds 3% of what is paid', (tester) async {
    final data = TestData();
    final company = (await tester.runAsync(data.createCompany))!;
    await tester.runAsync(
      () => data.database
          .into(data.database.customers)
          .insert(
            CustomersCompanion.insert(
              companyId: company.id,
              tipoDocumentoIdentidad: '6',
              numeroDocumentoIdentidad: '20100070970',
              nombre: 'PROVEEDOR S.A.C.',
            ),
          ),
    );
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      PerceptionRetentionFormPage(company, tipoComprobante: '20'),
    );
    await pumpUntil(tester, () => shows('R001-00000001'));
    await tester.tap(find.text(Strings.selectSupplier));
    await pumpUntil(tester, () => shows('PROVEEDOR S.A.C.'));
    await tester.tap(find.text('PROVEEDOR S.A.C.'));
    await pumpUntil(tester, () => !shows(Strings.selectSupplier));
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.facturaSerieNumero),
      'F002-15',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.facturaTotal),
      '1000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.importe),
      '500.55',
    );
    await pumpUntil(tester, () => shows('S/ 485.53'));
    expect(find.text('S/ 15.02'), findsOneWidget);

    bridge.responses.add(_accepted);
    await tester.tap(find.text(Strings.emit));
    await pumpUntil(tester, () => shows(Strings.viewDocument), 'sheet');
    final retention = (await tester.runAsync(
      () => data.database.select(data.database.documents).getSingle(),
    ))!;
    expect(retention.serie, 'R001');
    expect(retention.total, '15.02');
    await data.unmount(tester);
  });

  testWidgets('a guía from a factura asks before leaving once typed in', (
    tester,
  ) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);
    final company = (await tester.runAsync(
      () => data.companies.watchActive().first,
    ))!;
    Future<void> open() async {
      await pumpPage(
        tester,
        data,
        service,
        bridge,
        DespatchAdviceFormPage(company, related: factura),
      );
      await pumpUntil(tester, () => shows('T001-00000001'));
    }

    // The factura's goods and customer aren't the user's input
    await open();
    await tester.binding.handlePopRoute();
    await pumpUntil(
      tester,
      () => find.byType(DespatchAdviceFormPage).evaluate().isEmpty,
      'left without asking',
    );

    await open();
    await tester.enterText(
      find.widgetWithText(TextField, Strings.numeroBultos),
      '3',
    );
    await tester.pump();
    await tester.binding.handlePopRoute();
    await pumpUntil(tester, () => shows(Strings.discardChanges));
    await data.unmount(tester);
  });

  testWidgets('a guía carries the goods of its factura', (tester) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      DocumentDetailPage(documentId: factura.id),
    );
    await pumpUntil(tester, () => shows(Strings.guia));
    await tester.tap(find.text(Strings.guia));
    await pumpUntil(tester, () => shows('T001-00000001'));
    Finder inForm(String text) => find.descendant(
      of: find.byType(DespatchAdviceFormPage),
      matching: find.text(text),
    );
    expect(inForm('Café'), findsOneWidget); // from the factura
    expect(inForm('SUPERMERCADOS PERUANOS'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, Strings.pesoTotal),
      '3',
    );
    Future<void> tapVisible(String text) async {
      await tester.ensureVisible(find.text(text).last);
      await tester.pump();
      await tester.tap(find.text(text).last);
    }

    for (final label in [Strings.partida, Strings.llegada]) {
      await tapVisible(label);
      await pumpUntil(tester, () => shows(Strings.newAddress));
      // The sheet slides in before it takes taps
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.text(Strings.newAddress));
      await pumpUntil(tester, () => shows(Strings.ubigeo));
      await tester.pump(const Duration(seconds: 1));
      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.direccion),
        'Av. $label 1',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.ubigeo),
        '150101',
      );
      await tester.tap(find.text(Strings.save));
      await pumpUntil(tester, () => !shows(Strings.newAddress), label);
    }
    await tapVisible(Strings.vehiculoM1L);
    await tester.pump();

    await tapVisible(Strings.emit);
    await pumpUntil(tester, () => shows(Strings.viewDocument), 'sheet');
    final guia = (await tester.runAsync(
      () => (data.database.select(
        data.database.documents,
      )..where((d) => d.tipoComprobante.equals('09'))).getSingle(),
    ))!;
    expect(guia.affectedDocumentId, factura.id);
    expect(guia.sunatCode, LocalCodes.betaGuia);
    expect(
      (await tester.runAsync(
        () => data.database.select(data.database.addresses).get(),
      ))!,
      hasLength(2), // saved for next time
    );
    await data.unmount(tester);
  });

  testWidgets('a factura is emailed to the customer', (tester) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);
    await tester.runAsync(
      () => data.secureStore.writeCompanySecrets(factura.companyId, {
        CompanySecret.smtpHost: 'smtp.gmail.com',
        CompanySecret.smtpPort: '465',
        CompanySecret.smtpUsername: 'ventas@empresa.pe',
        CompanySecret.smtpPassword: 'app password',
      }),
    );

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      DocumentDetailPage(documentId: factura.id),
    );
    await pumpUntil(
      tester,
      () => find.byTooltip(Strings.deliver).evaluate().isNotEmpty,
    );
    await tester.pump(const Duration(seconds: 1)); // the page slides in
    await tester.tap(find.byTooltip(Strings.deliver));
    await pumpUntil(tester, () => shows(Strings.otherApps));
    await tester.pump(const Duration(seconds: 1)); // the sheet slides in
    await tester.tap(find.text(Strings.sendByEmail));
    await pumpUntil(
      tester,
      () => find
          .widgetWithText(TextFormField, Strings.email)
          .evaluate()
          .isNotEmpty,
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(
      find.widgetWithText(TextFormField, Strings.email),
      'compras@example.com',
    );
    await tester.tap(find.text(Strings.send));
    await pumpUntil(tester, () => shows(Strings.deliveries), 'delivery');

    expect(emailSender.sent.single.to, 'compras@example.com');
    expect(find.text('compras@example.com'), findsWidgets);
    await data.unmount(tester);
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

  testWidgets('a boleta in dollars converts catalog prices at its rate', (
    tester,
  ) async {
    final data = TestData();
    final company = (await tester.runAsync(() async {
      final company = await data.createCompany();
      await ProductRepository(data.database).create(
        ProductsCompanion.insert(
          companyId: company.id,
          descripcion: 'Café',
          precio: '4.00',
        ),
      );
      return company;
    }))!;
    final bridge = FakeBridge()
      ..total = '1.00'
      ..responses.add(_accepted);
    await pumpPage(
      tester,
      data,
      serviceFor(data, bridge),
      bridge,
      InvoiceFormPage(company, tipoComprobante: '03'),
    );
    await pumpUntil(tester, () => shows('B001-00000001'));

    await tester.tap(find.text(Catalogs.monedas['PEN']!));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text(Catalogs.monedas['USD']!).last);
    await tester.pump(const Duration(seconds: 1));
    final missingRate = find.text(
      draftProblemMessage(DraftProblem.missingTipoCambio),
    );
    expect(missingRate, findsOneWidget);
    // Without the rate a catalog price would go in unconverted
    await tester.tap(find.text(Strings.addProduct));
    await tester.pump();
    expect(missingRate, findsNWidgets(2)); // the warning and a message
    expect(find.text('Café'), findsNothing);
    await tester.pump(const Duration(seconds: 5)); // the message goes away
    await tester.enterText(
      find.widgetWithText(TextField, Strings.tipoCambio),
      '4',
    );
    await tester.tap(find.text(Strings.addProduct));
    await pumpUntil(tester, () => shows('Café'));
    await tester.tap(find.text('Café').last);
    await pumpUntil(tester, () => shows(r'1 × US$ 1.00'));

    await tester.tap(find.text(Strings.emit));
    await pumpUntil(tester, () => shows(Strings.viewDocument), 'sheet');
    final document = (await tester.runAsync(
      () => data.database.select(data.database.documents).getSingle(),
    ))!;
    expect(document.moneda, 'USD');
    expect(document.tipoCambio, '4');
    await data.unmount(tester);
  });

  testWidgets('DocumentsList searches, and notas de crédito subtract', (
    tester,
  ) async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final factura = await acceptedFactura(tester, data, service, bridge);
    final company = (await tester.runAsync(
      () => data.companies.watchActive().first,
    ))!;
    await tester.runAsync(() async {
      // A nota de crédito of the whole factura
      final fc01 = await (data.database.select(
        data.database.series,
      )..where((s) => s.serie.equals('FC01'))).getSingle();
      await service.emit(
        company: company,
        serie: fc01,
        draft: NoteDraft(
          tipoComprobante: '07',
          affected: factura,
          tipoNota: '01',
          sustento: 'Anulación',
          customer: const DraftCustomer(
            tipoDocumentoIdentidad: '6',
            numeroDocumentoIdentidad: '20100070970',
            nombre: 'SUPERMERCADOS PERUANOS',
          ),
          lines: const [
            DraftLine(descripcion: 'Café', cantidad: '2', precio: '59'),
          ],
        ),
      );
    });

    await pumpPage(
      tester,
      data,
      service,
      bridge,
      Scaffold(body: DocumentsList(company)),
    );
    await pumpUntil(
      tester,
      () => shows('F001-00000001 · ${factura.clienteNombre}'),
    );
    expect(find.text('S/ 118.00'), findsOneWidget); // the factura
    expect(find.text('−S/ 118.00'), findsOneWidget); // the nota

    await tester.enterText(find.byType(SearchBar), 'fc01');
    await tester.pump();
    expect(find.textContaining('F001-'), findsNothing);
    expect(find.textContaining('FC01-'), findsOneWidget);
    await data.unmount(tester);
  });

  test('two connections sending the same document send it once', () async {
    final data = TestData();
    final bridge = FakeBridge();
    final app = serviceFor(data, bridge);
    final background = serviceFor(data, bridge);
    final company = await data.createCompany();
    final b001 = await (data.database.select(
      data.database.series,
    )..where((s) => s.serie.equals('B001'))).getSingle();
    final id = await app.emit(company: company, serie: b001, draft: _boleta);
    bridge.responses.add(_accepted);

    await Future.wait([app.send(id), background.send(id)]);

    expect(bridge.calls, hasLength(1));
  });

  test('the background round notifies only SUNAT final answers', () async {
    final data = TestData();
    final bridge = FakeBridge();
    final service = serviceFor(data, bridge);
    final company = await data.createCompany();
    final b001 = await (data.database.select(
      data.database.series,
    )..where((s) => s.serie.equals('B001'))).getSingle();
    final accepted = await service.emit(
      company: company,
      serie: b001,
      draft: _boleta,
    );
    await service.emit(company: company, serie: b001, draft: _boleta);
    bridge.responses.addAll([
      _accepted,
      const SunatResponse(status: SunatStatus.notDelivered, notes: []),
    ]);
    final notified = <String>[];

    await runBackgroundOutbox(
      DocumentRepository(data.database),
      service,
      (document) async => notified.add(document.id),
    );

    expect(notified, [accepted]);
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
