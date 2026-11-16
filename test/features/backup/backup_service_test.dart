import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/backup/backup_service.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

import '../../data/generated/schema_v1.dart';

void main() {
  late Directory directory;
  late Directory temporary;
  late SecureStore store;
  late BackupService service;
  late File databaseFile;
  late AppDatabase database;

  Future<AppDatabase> openDatabase() async => AppDatabase(
    openEncryptedDatabase(
      databaseFile,
      await store.databaseKey(databaseExists: true),
    ),
  );

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    directory = await Directory.systemTemp.createTemp('backup');
    temporary = await Directory('${directory.path}/tmp').create();
    store = SecureStore();
    service = BackupService(store, () async => temporary);
    databaseFile = File('${directory.path}/xhandler.db');
    await store.databaseKey(databaseExists: false);
    database = await openDatabase();
    await database
        .into(database.companies)
        .insert(
          CompaniesCompanion.insert(ruc: '20123456789', razonSocial: 'Empresa'),
        );
    await store.writeCompanySecrets('c1', {
      CompanySecret.solPassword: 'clave sol',
    });
  });
  tearDown(() async {
    await database.close();
    await directory.delete(recursive: true);
  });

  Future<OpenedBackup> open(
    File backup, [
    String password = 'contraseña larga',
  ]) => service.open(
    backup,
    password: password,
    schemaVersion: database.schemaVersion,
  );

  test('a backup restores the data and secrets with its password', () async {
    final oldDevice = await database.deviceId();
    final backup = await service.create(database, 'contraseña larga');
    // Nothing readable without the password, and nothing else left behind
    final text = String.fromCharCodes(await backup.readAsBytes());
    expect(text, isNot(contains('Empresa')));
    expect(text, isNot(contains('clave sol')));
    expect(temporary.listSync().map((file) => file.path), [backup.path]);

    // A secret of a company that isn't in the backup goes away
    await store.writeCompanySecrets('c2', {CompanySecret.solPassword: 'otra'});
    final opened = await open(backup);
    expect(opened.secrets, {'company/c1/solPassword': 'clave sol'});

    await database.close();
    await service.install(opened, databaseFile);
    database = await openDatabase();
    expect(
      (await database.select(database.companies).getSingle()).razonSocial,
      'Empresa',
    );
    expect((await store.readCompanySecrets('c1')).solPassword, 'clave sol');
    expect((await store.readCompanySecrets('c2')).solPassword, isNull);
    expect(opened.database.existsSync(), isFalse);
    expect(File('${databaseFile.path}.restore').existsSync(), isFalse);
    // The restored phone is another device (docs/DESIGN.md §3.1)
    expect(await database.deviceId(), isNot(oldDevice));
  });

  test('a wrong password opens nothing', () async {
    final backup = await service.create(database, 'contraseña larga');
    await expectLater(open(backup, 'otra'), throwsA(isA<WrongPasswordError>()));
  });

  test(
    'a changed or cut database is refused, the phone is untouched',
    () async {
      final backup = await service.create(database, 'contraseña larga');
      final bytes = await backup.readAsBytes();
      final changed = File('${directory.path}/changed')
        ..writeAsBytesSync([...bytes]..[bytes.length - 100] ^= 0xff);
      final cut = File('${directory.path}/cut')
        ..writeAsBytesSync(bytes.sublist(0, bytes.length - 4096));
      for (final damaged in [changed, cut]) {
        await expectLater(open(damaged), throwsA(isA<WrongPasswordError>()));
      }
      expect(temporary.listSync().map((file) => file.path), [
        backup.path,
      ], reason: 'no half-prepared database left');
      expect(await database.select(database.companies).get(), hasLength(1));
    },
  );

  test('other files, cut headers and newer versions are refused', () async {
    final backup = await service.create(database, 'contraseña larga');
    final bytes = await backup.readAsBytes();
    for (final (name, content) in [
      ('text', 'not a backup at all, really'.codeUnits),
      ('header', bytes.sublist(0, 40)),
      ('secrets', bytes.sublist(0, 4 + 16 + 12 + 4 + 10)),
    ]) {
      final file = File('${directory.path}/$name')..writeAsBytesSync(content);
      await expectLater(
        open(file),
        throwsA(isA<InvalidBackupError>()),
        reason: name,
      );
    }
    await expectLater(
      service.open(
        backup,
        password: 'contraseña larga',
        schemaVersion: database.schemaVersion - 1,
      ),
      throwsA(
        isA<InvalidBackupError>().having(
          (e) => e.newerVersion,
          'newerVersion',
          isTrue,
        ),
      ),
    );
  });

  group('one company', () {
    late Company second;

    setUp(() async {
      second = await database
          .into(database.companies)
          .insertReturning(
            CompaniesCompanion.insert(
              ruc: '20100070970',
              razonSocial: 'Segunda S.A.C.',
            ),
          );
      await database
          .into(database.customers)
          .insert(
            CustomersCompanion.insert(
              companyId: second.id,
              tipoDocumentoIdentidad: '6',
              numeroDocumentoIdentidad: '20601030013',
              nombre: 'Cliente de la segunda',
            ),
          );
      await store.writeCompanySecrets(second.id, {
        CompanySecret.solPassword: 'clave de la segunda',
      });
    });

    Future<AppDatabase> openFile(File file) async => AppDatabase(
      openEncryptedDatabase(
        file,
        await store.databaseKey(databaseExists: true),
      ),
    );

    test('an export holds that company alone, with its secrets', () async {
      final backup = await service.create(
        database,
        'contraseña larga',
        onlyCompanyId: second.id,
      );
      final opened = await open(backup);
      expect(opened.secrets, {
        'company/${second.id}/solPassword': 'clave de la segunda',
      });

      final exported = await openFile(opened.database);
      addTearDown(exported.close);
      expect(
        (await exported.select(exported.companies).get()).map((c) => c.ruc),
        ['20100070970'],
      );
      expect(await exported.select(exported.customers).get(), hasLength(1));
      expect(await exported.select(exported.deviceSettings).get(), isEmpty);
    });

    test('importing adds the companies this phone lacks, with their data '
        'and secrets', () async {
      final backup = await service.create(database, 'contraseña larga');
      // Another phone, which has the first company (its own copy) only
      final other = await openFile(File('${directory.path}/other.db'));
      addTearDown(other.close);
      await other
          .into(other.companies)
          .insert(
            CompaniesCompanion.insert(ruc: '20123456789', razonSocial: 'Mía'),
          );
      await store.deleteCompanySecrets(second.id);

      final added = await service.merge(await open(backup), other);

      expect(added, ['Segunda S.A.C.']);
      final companies = await other.select(other.companies).get();
      expect(
        companies.map((c) => c.razonSocial),
        unorderedEquals(['Mía', 'Segunda S.A.C.']),
      );
      final customers = await other.select(other.customers).get();
      expect(customers.single.companyId, second.id);
      expect(
        (await store.readCompanySecrets(second.id)).solPassword,
        'clave de la segunda',
      );
      expect(temporary.listSync().map((file) => file.path), [backup.path]);

      // Again: nothing new to add
      expect(await service.merge(await open(backup), other), isEmpty);
    });
  });

  test('export and import know every table', () {
    expect(BackupService.knownTables, {
      for (final table in database.allTables) table.actualTableName,
    });
  });

  test(
    'importing copies documents, their files, deliveries and notas',
    () async {
      final company = await database.select(database.companies).getSingle();
      Future<Document> issue(String tipo, String serie, {String? affected}) =>
          database
              .into(database.documents)
              .insertReturning(
                DocumentsCompanion.insert(
                  companyId: company.id,
                  environment: SunatEnvironment.beta,
                  tipoComprobante: tipo,
                  serie: serie,
                  numero: 1,
                  fechaEmision: '2026-11-15',
                  clienteTipoDocumento: '6',
                  clienteNumeroDocumento: '20100070970',
                  clienteNombre: 'Cliente',
                  moneda: 'PEN',
                  total: '118.00',
                  status: DocumentStatus.accepted,
                  digestValue: 'hash',
                  inputJson: '{}',
                  enrichedJson: '{}',
                  deviceId: 'd',
                  affectedDocumentId: Value(affected),
                ),
              );
      final factura = await issue('01', 'F001');
      await issue('07', 'FC01', affected: factura.id);
      await database
          .into(database.documentFiles)
          .insert(
            DocumentFilesCompanion.insert(
              documentId: factura.id,
              kind: DocumentFileKind.signedXml,
              bytes: Uint8List.fromList([1, 2, 3]),
              sha256: 'sha',
            ),
          );
      await database
          .into(database.deliveries)
          .insert(
            DeliveriesCompanion.insert(
              documentId: factura.id,
              channel: DeliveryChannel.share,
              deviceId: 'd',
            ),
          );
      final backup = await service.create(database, 'contraseña larga');
      final other = AppDatabase(
        openEncryptedDatabase(
          File('${directory.path}/other.db'),
          await store.databaseKey(databaseExists: true),
        ),
      );
      addTearDown(other.close);

      expect(await service.merge(await open(backup), other), ['Empresa']);
      final documents = await other.select(other.documents).get();
      expect(
        documents.singleWhere((d) => d.serie == 'FC01').affectedDocumentId,
        factura.id,
      );
      expect(await other.select(other.documentFiles).get(), hasLength(1));
      expect(await other.select(other.deliveries).get(), hasLength(1));
    },
  );

  test('importing an older backup upgrades it first', () async {
    final key = await store.databaseKey(databaseExists: true);
    // A company in a schema 1 database, as an older backup holds
    final old = File('${directory.path}/v1.db');
    final v1 = DatabaseAtV1(openEncryptedDatabase(old, key));
    await v1.customStatement(
      'INSERT INTO companies (id, created_at, updated_at, ruc, razon_social) '
      "VALUES ('old', '2026-01-01T00:00:00.000Z', '2026-01-01T00:00:00.000Z', "
      "'20601030013', 'Antigua S.A.C.')",
    );
    await v1.close();

    expect(await service.merge(OpenedBackup(old, const {}), database), [
      'Antigua S.A.C.',
    ]);
    final imported = await (database.select(
      database.companies,
    )..where((c) => c.id.equals('old'))).getSingle();
    expect(imported.ruc, '20601030013');
    expect(imported.cuentaDetracciones, isNull);
    expect(imported.esAgentePercepcion, isFalse);
  });
}
