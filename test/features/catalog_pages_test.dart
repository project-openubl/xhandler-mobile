import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/providers.dart';
import 'package:xhandler_mobile/features/customer/customer_form_page.dart';
import 'package:xhandler_mobile/features/customer/customer_lookup.dart';
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
    await tester.enterText(_field('${Strings.precio} (PEN)'), '0');
    await data.tapAndWait(tester);
    expect(find.text(Strings.invalidPrecio), findsOneWidget);

    await tester.enterText(_field('${Strings.precio} (PEN)'), '4.50');
    await data.tapAndWait(tester);

    final products = (await tester.runAsync(
      () => ProductRepository(data.database).watch(company.id).first,
    ))!;
    expect(products.single.precio, '4.50');
    expect(products.single.igvTipo, isNull); // follows the company's default
    await data.unmount(tester);
  });

  testWidgets('ProductFormPage asks before losing what was typed', (
    tester,
  ) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    await data.pump(tester, ProductFormPage(company!));

    // Untouched, back just leaves
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ProductFormPage), findsNothing);

    await data.pump(tester, ProductFormPage(company));
    await tester.enterText(_field(Strings.descripcion), 'Café');
    await tester.pump();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text(Strings.discardChanges), findsOneWidget);

    await tester.tap(find.text(Strings.cancel));
    await tester.pumpAndSettle();
    expect(find.byType(ProductFormPage), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.discard));
    await tester.pumpAndSettle();
    expect(find.byType(ProductFormPage), findsNothing);
    await data.unmount(tester);
  });

  testWidgets('ProductFormPage needs an ISC rate with an ISC type', (
    tester,
  ) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    await data.pump(tester, ProductFormPage(company!));
    await tester.enterText(_field(Strings.descripcion), 'Cerveza');
    await tester.enterText(_field('${Strings.precio} (PEN)'), '7');

    await tester.tap(find.text(Strings.moreOptions));
    await tester.pumpAndSettle();
    await tester.tap(find.text('—'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sistema al valor').last);
    await tester.pumpAndSettle();
    await data.tapAndWait(tester);

    expect(find.text(Strings.invalidIscTasa), findsOneWidget);
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

    testWidgets('editing a customer keeps its own document', (tester) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      await data.pump(tester, CustomerFormPage(company!));
      await fillPassport(tester, 'AB123456');
      await data.tapAndWait(tester);
      final customer = await tester.runAsync(
        () =>
            CustomerRepository(data.database)
                .findByDocument(company.id, '7', 'AB123456'),
      );

      await data.pump(tester, CustomerFormPage(company, customer: customer));
      await tester.enterText(_field(Strings.nombre), 'John A. Smith');
      await data.tapAndWait(tester);

      expect(find.text(Strings.customerExists), findsNothing);
      final edited = await tester.runAsync(
        () =>
            CustomerRepository(data.database)
                .findByDocument(company.id, '7', 'AB123456'),
      );
      expect(edited?.nombre, 'John A. Smith');
      await data.unmount(tester);
    });

    testWidgets('a DNI has 8 digits', (tester) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      await data.pump(tester, CustomerFormPage(company!));
      await tester.tap(find.text('RUC'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('DNI').last);
      await tester.pumpAndSettle();
      await tester.enterText(_field(Strings.numeroDocumento), '1234567');
      await tester.enterText(_field(Strings.nombre), 'Juana');
      await data.tapAndWait(tester);

      expect(find.text(Strings.invalidDni), findsOneWidget);
      await data.unmount(tester);
    });

    testWidgets('the lookup fills name and address', (tester) async {
      final data = TestData();
      final company = await tester.runAsync(
        () => data.createCompany(lookupProvider: LookupProvider.decolecta),
      );
      final lookup = CustomerLookup(
        MockClient(
          (_) async => http.Response(
            '{"full_name": "PEREZ RUIZ JUANA", "direccion": "JR. UNION 100", "distrito": "LIMA"}',
            200,
          ),
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(data.database),
            customerLookupProvider.overrideWithValue(lookup),
          ],
          child: MaterialApp(home: CustomerFormPage(company!)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('RUC'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('DNI').last);
      await tester.pumpAndSettle();
      await tester.enterText(_field(Strings.numeroDocumento), '46027897');

      await tester.tap(find.byTooltip(Strings.lookup));
      for (
        var wait = 0;
        wait < 50 && find.text('PEREZ RUIZ JUANA').evaluate().isEmpty;
        wait++
      ) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump();
      }

      expect(find.text('PEREZ RUIZ JUANA'), findsOneWidget);
      expect(find.text('JR. UNION 100'), findsOneWidget);
      expect(find.byTooltip(Strings.lookup), findsOneWidget); // spinner gone
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
          lookupProvider: LookupProvider.decolecta,
        ),
      );
      await data.pump(tester, CustomerFormPage(company!));
      expect(find.byTooltip(Strings.lookup), findsOneWidget);
      await data.unmount(tester);
    });
  });

  testWidgets('LookupSettingsPage saves the Decolecta token', (tester) async {
    final data = TestData();
    final company = await tester.runAsync(data.createCompany);
    await data.pump(tester, LookupSettingsPage(company!));

    await tester.tap(find.text(Strings.lookupDecolecta));
    await tester.pumpAndSettle();
    await tester.enterText(_field(Strings.lookupToken), ' t0k ');
    await data.tapAndWait(tester);

    final saved = (await tester.runAsync(
      () => data.companies.watchActive().first,
    ))!;
    expect(saved.lookupProvider, LookupProvider.decolecta);
    final secrets = (await tester.runAsync(
      () => data.companies.readSecrets(company.id),
    ))!;
    expect(secrets.lookupToken, 't0k');
    await data.unmount(tester);
  });
}
