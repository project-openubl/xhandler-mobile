import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/company/company_repository.dart';
import 'package:xhandler_mobile/features/customer/customer_repository.dart';
import 'package:xhandler_mobile/features/product/product_repository.dart';
import 'package:xhandler_mobile/features/series/series_repository.dart';

void main() {
  late AppDatabase database;
  late CompanyRepository companies;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    database = AppDatabase(NativeDatabase.memory());
    companies = CompanyRepository(database, SecureStore());
  });
  tearDown(() => database.close());

  Future<String> createCompany([String ruc = '20123456789']) => companies
      .create(CompaniesCompanion.insert(ruc: ruc, razonSocial: 'Empresa $ruc'));

  group('CompanyRepository', () {
    test(
      'creates the company with its default series and activates it',
      () async {
        final id = await createCompany();

        expect((await companies.watchActive().first)?.id, id);
        final series = await SeriesRepository(database)
            .watchByCompany(id)
            .first;
        expect(
          series.map((s) => s.serie),
          containsAll(['F001', 'B001', 'FC01', 'BC01']),
        );
        expect(series.every((s) => s.isDefault && s.nextNumber == 1), isTrue);
      },
    );

    test('switches the active company', () async {
      await createCompany('20123456789');
      final second = await createCompany('20100070970');
      expect((await companies.watchActive().first)?.id, second);

      final all = await companies.watchAll().first;
      await companies.setActive(all.firstWhere((c) => c.id != second).id);
      expect((await companies.watchActive().first)?.ruc, '20123456789');
    });

    test('deletes softly and removes the secrets', () async {
      final id = await createCompany();
      await companies.writeSecrets(
        id,
        CompanySecrets(
          certificate: Uint8List.fromList([1, 2]),
          solPassword: 'x',
        ),
      );

      await companies.delete(id);

      expect(await companies.watchAll().first, isEmpty);
      expect(await companies.watchActive().first, isNull);
      final secrets = await companies.readSecrets(id);
      expect(secrets.certificate, isNull);
      expect(secrets.solPassword, isNull);
      final row = await (database.select(
        database.companies,
      )..where((c) => c.id.equals(id))).getSingle();
      expect(row.deletedAt, isNotNull);
    });

    test('keeps the secrets of each company apart', () async {
      final first = await createCompany('20123456789');
      final second = await createCompany('20100070970');
      await companies.writeSecrets(
        first,
        const CompanySecrets(solUsername: 'A'),
      );
      await companies.writeSecrets(
        second,
        const CompanySecrets(solUsername: 'B'),
      );

      expect((await companies.readSecrets(first)).solUsername, 'A');
      expect((await companies.readSecrets(second)).solUsername, 'B');
    });
  });

  test(
    'SeriesRepository.setDefault replaces the default of the same kind',
    () async {
      final id = await createCompany();
      final series = SeriesRepository(database);
      await series.save(
        SeriesCompanion.insert(
          companyId: id,
          tipoComprobante: '07',
          serie: 'FC02',
        ),
      );

      final fc02 = (await series.watchByCompany(id).first).firstWhere(
        (s) => s.serie == 'FC02',
      );
      await series.setDefault(fc02);

      final defaults = {
        for (final s in await series.watchByCompany(id).first)
          if (s.tipoComprobante == '07') s.serie: s.isDefault,
      };
      // BC01 (notas of boletas) stays the default of its kind
      expect(defaults, {'BC01': true, 'FC01': false, 'FC02': true});
    },
  );

  test('CustomerRepository searches by name or document number', () async {
    final id = await createCompany();
    final customers = CustomerRepository(database);
    await customers.save(
      CustomersCompanion.insert(
        companyId: id,
        tipoDocumentoIdentidad: '6',
        numeroDocumentoIdentidad: '20100070970',
        nombre: 'Supermercados Peruanos',
      ),
    );
    await customers.save(
      CustomersCompanion.insert(
        companyId: id,
        tipoDocumentoIdentidad: '1',
        numeroDocumentoIdentidad: '12345678',
        nombre: 'Juana Pérez',
      ),
    );

    expect(
      (await customers.watch(id, search: 'Juana').first)
          .single
          .numeroDocumentoIdentidad,
      '12345678',
    );
    expect(
      (await customers.watch(id, search: '2010').first).single.nombre,
      'Supermercados Peruanos',
    );
    expect(await customers.findByDocument(id, '1', '12345678'), isNotNull);
  });

  test(
    'ProductRepository lists favorites first and hides deleted ones',
    () async {
      final id = await createCompany();
      final products = ProductRepository(database);
      await products.save(
        ProductsCompanion.insert(
          companyId: id,
          descripcion: 'Agua',
          precio: '2.00',
        ),
      );
      await products.save(
        ProductsCompanion.insert(
          companyId: id,
          descripcion: 'Café',
          precio: '4.00',
          favorito: const Value(true),
        ),
      );

      var listed = await products.watch(id).first;
      expect(listed.map((p) => p.descripcion), ['Café', 'Agua']);

      await products.delete(listed.first.id);
      listed = await products.watch(id).first;
      expect(listed.map((p) => p.descripcion), ['Agua']);
    },
  );
}
