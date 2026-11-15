// End-to-end walk through the app on a device, in test mode against SUNAT
// beta with SUNAT's demo certificate. How to run it: README.md.
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/tables.dart';
import 'package:xhandler_mobile/features/company/company_repository.dart';
import 'package:xhandler_mobile/features/document/document_repository.dart';
import 'package:xhandler_mobile/features/document/document_status.dart';
import 'package:xhandler_mobile/features/pdf/pdf_templates.dart';
import 'package:xhandler_mobile/features/pdf/share_document.dart';
import 'package:xhandler_mobile/main.dart' as app;
import 'package:xhandler_mobile/strings.dart';

const _ruc = '20601030013';
const _razonSocial = 'EMPRESA E2E S.A.C.';
const _customerRuc = '20100070970';
const _customerName = 'CLIENTE E2E S.A.';
const _product = 'Café pasado';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  var shot = 0;

  /// Lets page transitions finish (pumpAndSettle never ends while a spinner
  /// spins)
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Future<void> screenshot(WidgetTester tester, String name) async {
    // Let the last frame reach the screen before capturing it
    await settle(tester);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await tester.pump();
    shot++;
    await binding.takeScreenshot('${shot.toString().padLeft(2, '0')}-$name');
  }

  /// Pumps until [finder] finds something, up to [timeout]. On timeout it
  /// saves a "failure" screenshot and prints the texts on screen.
  Future<void> waitFor(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
    String? reason,
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 200));
      if (finder.evaluate().isNotEmpty) return;
    }
    await binding.takeScreenshot('failure');
    final texts = find
        .byType(RichText)
        .evaluate()
        .map((e) => (e.widget as RichText).text.toPlainText());
    debugPrint('On screen: ${texts.join(' | ')}');
    fail('Timed out waiting for $finder${reason == null ? '' : ': $reason'}');
  }

  /// Taps the last tappable widget of [finder] once it is on screen. Hidden
  /// copies (e.g. in the route below) don't count.
  Future<void> tap(WidgetTester tester, Finder finder) async {
    await waitFor(tester, finder);
    await tester.ensureVisible(finder.last);
    await waitFor(tester, finder.hitTestable());
    await tester.tap(finder.hitTestable().last);
    await settle(tester);
  }

  Future<void> tapText(WidgetTester tester, String text) =>
      tap(tester, find.text(text));

  /// Types [text] in the field labelled [label] (required fields add " *")
  Future<void> enter(WidgetTester tester, String label, String text) async {
    final fields = find.ancestor(
      of: find.textContaining(
        RegExp('^${RegExp.escape(label)}( \\*)?\$'),
        findRichText: true,
      ),
      matching: find.byType(TextFormField),
    );
    await waitFor(tester, fields);
    await tester.ensureVisible(fields.first);
    await tester.enterText(fields.first, text);
    await tester.pump();
  }

  Future<void> openDrawerItem(WidgetTester tester, String item) async {
    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await settle(tester);
    await tapText(tester, item);
  }

  /// Android's back button
  Future<void> back(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await settle(tester);
  }

  /// Emits the open form and opens the document once SUNAT answers
  Future<void> emitAndView(WidgetTester tester, String name) async {
    await tapText(tester, Strings.emit);
    await waitFor(tester, find.text(Strings.viewDocument));
    await screenshot(tester, '$name-result');
    expect(find.text(DocumentStatus.accepted.label), findsOneWidget);
    await tapText(tester, Strings.viewDocument);
    await waitFor(tester, find.text(Strings.timeline));
    await screenshot(tester, '$name-detail');
  }

  /// Every PDF template prints the factura, delivered with its XML and CDR
  Future<void> expectDeliveryFiles(WidgetTester tester) async {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );
    final documents = container.read(documentRepositoryProvider);
    final company = (await container
        .read(companyRepositoryProvider)
        .findByRuc(_ruc))!;
    final factura =
        (await documents.watch(company.id, company.sunatEnvironment).first)
            .firstWhere((d) => d.tipoComprobante == '01');
    for (final template in pdfTemplates) {
      final files = await deliveryFiles(
        company: company,
        document: factura,
        documents: documents,
        template: template,
      );
      expect(String.fromCharCodes(files.first.bytes.take(4)), '%PDF');
      expect(files.map((f) => f.name), contains(endsWith('.xml')));
      expect(files.map((f) => f.name), contains(endsWith('.zip'))); // CDR
    }
  }

  testWidgets('a company issues, voids and reports its documents', (
    tester,
  ) async {
    await app.main();
    // Android screenshots need the Flutter surface as an image
    if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();
    await waitFor(
      tester,
      find.text(Strings.welcomeTitle),
      reason: 'the test needs a fresh install (see README.md)',
    );
    await screenshot(tester, 'welcome');

    // Company in test mode: SUNAT's demo certificate, MODDATOS user
    await tapText(tester, Strings.createCompany);
    await screenshot(tester, 'company-form');
    await enter(tester, Strings.ruc, _ruc);
    await enter(tester, Strings.razonSocial, _razonSocial);
    await enter(tester, Strings.direccion, 'Av. Arequipa 123');
    await enter(tester, Strings.distrito, 'Lima');
    await enter(tester, Strings.provincia, 'Lima');
    await enter(tester, Strings.departamento, 'Lima');
    await enter(tester, Strings.ubigeo, '150101');
    await tapText(tester, Strings.save);
    // The new company becomes the active one: its (empty) home shows
    await waitFor(tester, find.text(Strings.newDocument));
    await screenshot(tester, 'home-empty');

    // Catalog: a favorite product and a customer with RUC
    await openDrawerItem(tester, Strings.products);
    await tap(tester, find.byTooltip(Strings.newProduct));
    await enter(tester, Strings.descripcion, _product);
    await enter(tester, '${Strings.precio} (PEN)', '8.50');
    await tapText(tester, Strings.favorito);
    await screenshot(tester, 'product-form');
    await tapText(tester, Strings.save);
    await waitFor(tester, find.text(_product));
    await screenshot(tester, 'products');
    await back(tester);

    await openDrawerItem(tester, Strings.customers);
    await tap(tester, find.byTooltip(Strings.newCustomer));
    await enter(tester, Strings.numeroDocumento, _customerRuc);
    await enter(tester, Strings.nombre, _customerName);
    await screenshot(tester, 'customer-form');
    await tapText(tester, Strings.save);
    await waitFor(tester, find.text(_customerName));
    await back(tester);

    // Quick sale: a boleta to "Clientes varios"
    await tapText(tester, Strings.newDocument);
    await screenshot(tester, 'new-document-sheet');
    await tapText(tester, Strings.quickSale);
    await tapText(tester, _product);
    await tap(tester, find.byTooltip(Strings.add)); // one more
    await screenshot(tester, 'quick-sale');
    await tap(tester, find.textContaining('${Strings.charge} S/'));
    await waitFor(tester, find.text(Strings.newSale));
    await screenshot(tester, 'quick-sale-result');
    expect(find.text(DocumentStatus.accepted.label), findsOneWidget);
    await back(tester); // the result sheet
    await back(tester); // the quick sale

    // Full form: a factura with a free line
    await tapText(tester, Strings.newDocument);
    await tapText(tester, Strings.factura);
    await tapText(tester, Strings.selectCustomer);
    await tapText(tester, _customerName);
    await tapText(tester, Strings.freeLine);
    await enter(tester, Strings.descripcion, 'Servicio de consultoría');
    await enter(tester, Strings.precio, '100');
    await tapText(tester, Strings.add);
    await waitFor(tester, find.text('S/ 15.25')); // IGV included in 100
    await screenshot(tester, 'factura-form');
    await emitAndView(tester, 'factura');

    // Delivery (the system share sheet itself can't be driven)
    await tap(tester, find.byTooltip(Strings.deliver));
    await waitFor(tester, find.text(Strings.otherApps));
    await screenshot(tester, 'delivery-sheet');
    await back(tester);
    await expectDeliveryFiles(tester);

    // Nota de crédito on the factura
    await tapText(tester, Strings.notaCredito);
    await waitFor(tester, find.textContaining('FC01-'));
    await screenshot(tester, 'nota-credito-form');
    await emitAndView(tester, 'nota-credito');
    await back(tester); // to the factura
    await back(tester); // to home

    // Void the boleta (resumen diario)
    await tap(tester, find.textContaining('B001-'));
    await tapText(tester, Strings.voidDocument);
    await enter(tester, Strings.motivo, 'Error en el precio');
    await screenshot(tester, 'void-dialog');
    await tapText(tester, Strings.voidDocument);
    // The resumen diario is answered through a ticket the app asks for later
    await waitFor(
      tester,
      find.textContaining(Strings.voidedBy('RC-')),
      timeout: const Duration(seconds: 120),
    );
    await screenshot(tester, 'boleta-voided');
    await back(tester);
    await screenshot(tester, 'home-documents');

    // Reports
    await openDrawerItem(tester, Strings.reports);
    await waitFor(tester, find.text(Strings.export));
    await screenshot(tester, 'reports');
    await back(tester);

    // Backup page (its share sheet is the system's)
    await openDrawerItem(tester, Strings.backupTitle);
    await waitFor(tester, find.text(Strings.createBackup));
    await screenshot(tester, 'backup');
    await back(tester);

    // Company settings
    await openDrawerItem(tester, Strings.companySettings);
    await waitFor(tester, find.text(Strings.certificate));
    await screenshot(tester, 'settings');
  });
}
