import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/backup/backup_service.dart';

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
      service.open(backup, password: 'contraseña larga', schemaVersion: 1),
      throwsA(
        isA<InvalidBackupError>().having(
          (e) => e.newerVersion,
          'newerVersion',
          isTrue,
        ),
      ),
    );
  });

  test('a backup of an older version migrates when opened', () async {
    // As the app was in schema 2, before deliveries were recorded
    await database.customStatement('DROP TABLE deliveries');
    await database.customStatement('PRAGMA user_version = 2');
    final backup = await service.create(database, 'contraseña larga');
    final opened = await open(backup);

    await database.close();
    await service.install(opened, databaseFile);
    database = await openDatabase();
    expect(await database.select(database.deliveries).get(), isEmpty);
  });
}
