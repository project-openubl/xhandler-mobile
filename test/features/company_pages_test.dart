import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/providers.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/company/active_company_page.dart';
import 'package:xhandler_mobile/features/company/company_repository.dart';
import 'package:xhandler_mobile/features/company/credentials_page.dart';
import 'package:xhandler_mobile/features/series/series_page.dart';
import 'package:xhandler_mobile/strings.dart';

void main() {
  late AppDatabase database;
  late CompanyRepository companies;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    database = AppDatabase(NativeDatabase.memory());
    companies = CompanyRepository(database, SecureStore());
  });
  tearDown(() => database.close());

  Future<Company> createCompany() async {
    await companies.create(
      CompaniesCompanion.insert(ruc: '20123456789', razonSocial: 'Empresa'),
    );
    return (await companies.watchActive().first)!;
  }

  /// Unmounts the app and runs the timer Drift schedules when its stream
  /// queries close, so no timer is left pending
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  Future<void> pump(WidgetTester tester, Widget page) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(home: page),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('CredentialsPage', () {
    testWidgets('shows the saved credentials without the RUC prefix', (
      tester,
    ) async {
      final company = await tester.runAsync(createCompany);
      await companies.writeSecrets(company!.id, {
        CompanySecret.solUsername: '20123456789USUARIO',
        CompanySecret.solPassword: 'clave',
      });

      await pump(tester, CredentialsPage(company));

      expect(find.text('USUARIO'), findsOneWidget);
      expect(find.text('20123456789'), findsOneWidget); // the prefix
      await unmount(tester);
    });

    testWidgets('clearing a field deletes only that secret', (tester) async {
      final company = await tester.runAsync(createCompany);
      await companies.writeSecrets(company!.id, {
        CompanySecret.certificate: 'AQI=',
        CompanySecret.solUsername: '20123456789USUARIO',
        CompanySecret.greClientId: 'client',
      });
      await pump(tester, CredentialsPage(company));

      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.greClientId),
        '',
      );
      await tester.tap(find.text(Strings.save));
      await tester.pumpAndSettle();

      final secrets = await companies.readSecrets(company.id);
      expect(secrets.greClientId, isNull);
      expect(secrets.solUsername, '20123456789USUARIO');
      expect(secrets.certificate, isNotNull);
      await unmount(tester);
    });
  });

  group('SeriesPage', () {
    Future<void> addSerie(WidgetTester tester, String serie) async {
      await tester.tap(find.byTooltip(Strings.addSerie));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, Strings.serie),
        serie,
      );
      await tester.tap(find.text(Strings.save));
      await tester.pumpAndSettle();
    }

    testWidgets('checks the serie prefix of the document type', (tester) async {
      final company = await tester.runAsync(createCompany);
      await pump(tester, SeriesPage(company!));

      await addSerie(tester, 'B002'); // a factura serie starts with F

      expect(find.text(Strings.invalidSerie('F')), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('says when the serie already exists', (tester) async {
      final company = await tester.runAsync(createCompany);
      await pump(tester, SeriesPage(company!));

      await tester.runAsync(() => addSerie(tester, 'F001'));
      await tester.pumpAndSettle();

      expect(find.text(Strings.serieExists), findsOneWidget);
      await unmount(tester);
    });
  });

  testWidgets('ActiveCompanyPage goes home when there is no company', (
    tester,
  ) async {
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
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    await unmount(tester);
  });
}
