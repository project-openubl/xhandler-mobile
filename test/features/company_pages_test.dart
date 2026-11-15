import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/providers.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/company/active_company_page.dart';
import 'package:xhandler_mobile/features/company/company_form_page.dart';
import 'package:xhandler_mobile/features/company/credentials_page.dart';
import 'package:xhandler_mobile/features/series/series_page.dart';
import 'package:xhandler_mobile/strings.dart';

import '../helpers.dart';

void main() {
  group('CompanyFormPage', () {
    testWidgets('marks the required fields and rejects them empty', (
      tester,
    ) async {
      final data = TestData();
      await data.pump(tester, const CompanyFormPage());

      expect(find.text('* ${Strings.requiredFieldsLegend}'), findsOneWidget);
      expect(find.text('${Strings.ruc} *'), findsOneWidget);
      expect(find.text('${Strings.razonSocial} *'), findsOneWidget);
      expect(find.text(Strings.nombreComercial), findsOneWidget);
      expect(find.text('${Strings.nombreComercial} *'), findsNothing);

      await tester.tap(find.text(Strings.save));
      await tester.pumpAndSettle();
      expect(find.text(Strings.required), findsNWidgets(2));
      await data.unmount(tester);
    });

    testWidgets('saves whether SUNAT made it a percepción/retención agent', (
      tester,
    ) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      expect(company!.esAgentePercepcion, isFalse);
      expect(company.esAgenteRetencion, isFalse);
      await data.pump(tester, CompanyFormPage(company: company));

      for (final label in [Strings.agentePercepcion, Strings.agenteRetencion]) {
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }
      await data.tapAndWait(tester);

      final saved = (await tester.runAsync(
        () => data.companies.watchActive().first,
      ))!;
      expect(saved.esAgentePercepcion, isTrue);
      expect(saved.esAgenteRetencion, isTrue);
      await data.unmount(tester);
    });
  });

  group('CredentialsPage', () {
    testWidgets('shows the saved credentials without the RUC prefix', (
      tester,
    ) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      await tester.runAsync(
        () => data.companies.writeSecrets(company!.id, {
          CompanySecret.solUsername: '20123456789USUARIO',
          CompanySecret.solPassword: 'clave',
        }),
      );

      await data.pump(tester, CredentialsPage(company!));

      expect(find.text('USUARIO'), findsOneWidget);
      expect(find.text('20123456789'), findsOneWidget); // the prefix
      await data.unmount(tester);
    });

    testWidgets('clearing a field deletes only that secret', (tester) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      await tester.runAsync(
        () => data.companies.writeSecrets(company!.id, {
          CompanySecret.certificate: 'AQI=',
          CompanySecret.solUsername: '20123456789USUARIO',
          CompanySecret.greClientId: 'client',
        }),
      );
      await data.pump(tester, CredentialsPage(company!));

      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.greClientId),
        '',
      );
      await data.tapAndWait(tester);

      final secrets = (await tester.runAsync(
        () => data.companies.readSecrets(company.id),
      ))!;
      expect(secrets.greClientId, isNull);
      expect(secrets.solUsername, '20123456789USUARIO');
      expect(secrets.certificate, isNotNull);
      await data.unmount(tester);
    });
  });

  group('SeriesPage', () {
    Future<void> addSerie(
      WidgetTester tester,
      TestData data,
      String serie,
    ) async {
      await tester.tap(find.byTooltip(Strings.addSerie));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.serie),
        serie,
      );
      await data.tapAndWait(tester);
    }

    testWidgets('checks the serie prefix of the document type', (tester) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      await data.pump(tester, SeriesPage(company!));

      await addSerie(tester, data, 'B002'); // a factura serie starts with F

      expect(find.text(Strings.invalidSerie('F')), findsOneWidget);
      await data.unmount(tester);
    });

    testWidgets('says when the serie already exists', (tester) async {
      final data = TestData();
      final company = await tester.runAsync(data.createCompany);
      await data.pump(tester, SeriesPage(company!));

      await addSerie(tester, data, 'F001');

      expect(find.text(Strings.serieExists), findsOneWidget);
      await data.unmount(tester);
    });
  });

  testWidgets('ActiveCompanyPage goes home when there is no company', (
    tester,
  ) async {
    final data = TestData();
    final router = GoRouter(
      initialLocation: '/page',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('home')),
        GoRoute(
          path: '/page',
          builder: (_, _) =>
              ActiveCompanyPage(builder: (company) => Text(company.ruc)),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(data.database)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    await data.unmount(tester);
  });
}
