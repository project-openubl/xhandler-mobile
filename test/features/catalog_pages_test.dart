import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/customer/customer_form_page.dart';
import 'package:xhandler_mobile/features/customer/customer_repository.dart';
import 'package:xhandler_mobile/features/customer/lookup_settings_page.dart';
import 'package:xhandler_mobile/features/product/product_form_page.dart';
import 'package:xhandler_mobile/features/product/product_repository.dart';
import 'package:xhandler_mobile/strings.dart';

import '../helpers.dart';

Finder _field(String label) => find.widgetWithText(TextFormField, label);

void main() {
  testWidgets('ProductFormPage checks the price and saves the product', (
    tester,
  ) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    await data.pump(tester, ProductFormPage(company!));

    await tester.enterText(_field(Strings.descripcion), 'Café');
    await tester.enterText(_field('${Strings.precio} (PEN)'), '4,50');
    await data.tapAndWait(tester);
    expect(find.text(Strings.invalidPrecio), findsOneWidget);

    await tester.enterText(_field('${Strings.precio} (PEN)'), '4.50');
    await data.tapAndWait(tester);

    final products = (await tester.runAsync(
      () => ProductRepository(data.database).watch(company.id).first,
    ))!;
    expect(products.single.precio, '4.50');
    expect(products.single.igvTipo, '10'); // the company's default
    await data.unmount(tester);
  });

  group('CustomerFormPage', () {
    // Passports (Catalog 6 "7") need no bridge validation in widget tests
    Future<void> fillPassport(WidgetTester tester, String numero) async {
      await tester.tap(find.text('RUC'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pasaporte').last);
      await tester.pumpAndSettle();
      await tester.enterText(_field(Strings.numeroDocumento), numero);
      await tester.enterText(_field(Strings.nombre), 'John Smith');
    }

    testWidgets('saves a customer and refuses its document twice', (
      tester,
    ) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      await data.pump(tester, CustomerFormPage(company!));
      await fillPassport(tester, 'AB123456');
      await data.tapAndWait(tester);

      final saved = await tester.runAsync(
        () =>
            CustomerRepository(data.database)
                .findByDocument(company.id, '7', 'AB123456'),
      );
      expect(saved, isNotNull);

      await data.pump(tester, CustomerFormPage(company));
      await fillPassport(tester, 'AB123456');
      await data.tapAndWait(tester);
      expect(find.text(Strings.customerExists), findsOneWidget);
      await data.unmount(tester);
    });

    testWidgets('offers the lookup only when a service is set', (tester) async {
      final data = TestData();
      var company = await tester.runAsync(data.createCompany);
      await data.pump(tester, CustomerFormPage(company!));
      expect(find.byTooltip(Strings.lookup), findsNothing);

      company = await tester.runAsync(
        () => data.createCompany(
          ruc: '20100070970',
          lookupProvider: LookupProvider.commercial,
        ),
      );
      await data.pump(tester, CustomerFormPage(company!));
      expect(find.byTooltip(Strings.lookup), findsOneWidget);
      await data.unmount(tester);
    });
  });

  testWidgets('LookupSettingsPage keeps searchpe access as user:password', (
    tester,
  ) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    await data.pump(tester, LookupSettingsPage(company!));

    await tester.tap(find.text(Strings.lookupSearchpe));
    await tester.pumpAndSettle();
    await tester.enterText(
      _field(Strings.lookupUrl),
      'https://searchpe.example.com',
    );
    await tester.enterText(_field(Strings.lookupUser), 'admin');
    await tester.enterText(_field(Strings.lookupPassword), 'se:cret');
    await data.tapAndWait(tester);

    final saved = (await tester.runAsync(
      () => data.companies.watchActive().first,
    ))!;
    expect(saved.lookupProvider, LookupProvider.searchpe);
    expect(saved.lookupUrl, 'https://searchpe.example.com');
    final secrets = (await tester.runAsync(
      () => data.companies.readSecrets(company.id),
    ))!;
    expect(secrets.lookupToken, 'admin:se:cret');
    await data.unmount(tester);
  });
}
