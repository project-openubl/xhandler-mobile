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
        expect(series, hasLength(9));
        expect(series.every((s) => s.isDefault && s.nextNumber == 1), isTrue);
      },
    );

    test('updates only the given columns and stamps updated_at', () async {
      final id = await createCompany();
      final before = (await companies.watchActive().first)!;

      await companies.update(
        id,
        const CompaniesCompanion(telefono: Value('01 1234567')),
      );

      final after = (await companies.watchActive().first)!;
      expect(after.telefono, '01 1234567');
      expect(after.razonSocial, before.razonSocial);
      expect(after.updatedAt.isAfter(before.updatedAt), isTrue);
    });

    test('deleting the active company activates another one', () async {
      final first = await createCompany('20123456789');
      final second = await createCompany('20100070970');

      await companies.delete(second);
      expect((await companies.watchActive().first)?.id, first);

      await companies.delete(first);
      expect(await companies.watchActive().first, isNull);
      expect(await companies.watchAll().first, isEmpty);
    });

    test('a deleted company can be created again, but not twice', () async {
      final id = await createCompany();
      await expectLater(createCompany(), throwsA(isA<SqliteException>()));

      await companies.delete(id);
      expect(await companies.findByRuc('20123456789'), isNull);
      await createCompany();
      expect(await companies.findByRuc('20123456789'), isNotNull);
    });

    test('updates never revive a deleted company', () async {
      final id = await createCompany();
      await companies.delete(id);

      await companies.update(
        id,
        const CompaniesCompanion(razonSocial: Value('B')),
      );

      expect(await companies.watchAll().first, isEmpty);
    });

    test('secrets are written one by one and deleted all at once', () async {
      final first = await createCompany('20123456789');
      final second = await createCompany('20100070970');
      await companies.writeSecrets(first, {
        CompanySecret.certificate: 'AQI=',
        CompanySecret.solPassword: 'x',
      });
      await companies.writeSecrets(second, {CompanySecret.solUsername: 'B'});

      await companies.writeSecrets(first, {CompanySecret.solPassword: null});
      var secrets = await companies.readSecrets(first);
      expect(secrets.certificate, [1, 2]);
      expect(secrets.solPassword, isNull);

      await companies.delete(first);
      secrets = await companies.readSecrets(first);
      expect(secrets.certificate, isNull);
      expect((await companies.readSecrets(second)).solUsername, 'B');
    });
  });

  group('SeriesRepository', () {
    test('lists series by document type, then serie', () async {
      final id = await createCompany();
      final series = await SeriesRepository(database).watchByCompany(id).first;
      expect(series.map((s) => s.serie), [
        'F001',
        'B001',
        'BC01',
        'FC01',
        'BD01',
        'FD01',
        'T001',
        'R001',
        'P001',
      ]);
    });

    test('setDefault replaces the default of the same kind', () async {
      final id = await createCompany();
      final series = SeriesRepository(database);
      await series.create(
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
    });

    test('a serie exists once per document type', () async {
      final id = await createCompany();
      await expectLater(
        SeriesRepository(database).create(
          SeriesCompanion.insert(
            companyId: id,
            tipoComprobante: '01',
            serie: 'F001',
          ),
        ),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('CustomerRepository', () {
    late String companyId;
    late CustomerRepository customers;

    setUp(() async {
      companyId = await createCompany();
      customers = CustomerRepository(database);
      await customers.create(
        CustomersCompanion.insert(
          companyId: companyId,
          tipoDocumentoIdentidad: '6',
          numeroDocumentoIdentidad: '20100070970',
          nombre: 'Supermercados Peruanos 100%',
        ),
      );
      await customers.create(
        CustomersCompanion.insert(
          companyId: companyId,
          tipoDocumentoIdentidad: '1',
          numeroDocumentoIdentidad: '12345678',
          nombre: 'Juana Pérez',
        ),
      );
    });

    test('searches by name or document number, literally', () async {
      expect(
        (await customers.watch(companyId, search: 'Juana').first)
            .single
            .numeroDocumentoIdentidad,
        '12345678',
      );
      expect(
        (await customers.watch(companyId, search: '2010').first).single.nombre,
        startsWith('Super'),
      );
      expect(
        (await customers.watch(companyId, search: '100%').first),
        hasLength(1),
      );
      expect(
        (await customers.watch(companyId, search: '%').first),
        hasLength(1),
      );
    });

    test('a deleted customer can be registered again', () async {
      final juana = await customers.findByDocument(companyId, '1', '12345678');
      await customers.delete(juana!.id);
      expect(
        await customers.findByDocument(companyId, '1', '12345678'),
        isNull,
      );

      await customers.create(
        CustomersCompanion.insert(
          companyId: companyId,
          tipoDocumentoIdentidad: '1',
          numeroDocumentoIdentidad: '12345678',
          nombre: 'Juana Pérez Ruiz',
        ),
      );
      expect(
        (await customers.findByDocument(companyId, '1', '12345678'))?.nombre,
        'Juana Pérez Ruiz',
      );
    });

    test('a document number is registered once', () async {
      await expectLater(
        customers.create(
          CustomersCompanion.insert(
            companyId: companyId,
            tipoDocumentoIdentidad: '1',
            numeroDocumentoIdentidad: '12345678',
            nombre: 'Otra',
          ),
        ),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  test(
    'ProductRepository lists favorites first and hides deleted ones',
    () async {
      final id = await createCompany();
      final products = ProductRepository(database);
      await products.create(
        ProductsCompanion.insert(
          companyId: id,
          descripcion: 'Agua',
          precio: '2.00',
        ),
      );
      await products.create(
        ProductsCompanion.insert(
          companyId: id,
          descripcion: 'Café',
          precio: '4.00',
          favorito: const Value(true),
        ),
      );

      var listed = await products.watch(id).first;
      expect(listed.map((p) => p.descripcion), ['Café', 'Agua']);

      await products.update(
        listed.last.id,
        const ProductsCompanion(precio: Value('2.50')),
      );
      await products.delete(listed.first.id);
      listed = await products.watch(id).first;
      expect(listed.map((p) => '${p.descripcion} ${p.precio}'), ['Agua 2.50']);
    },
  );
}
