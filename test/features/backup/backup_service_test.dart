import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/features/backup/backup_service.dart';

void main() {
  late Directory directory;
  late SecureStore store;
  late BackupService service;
  late File databaseFile;
  late AppDatabase database;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    directory = await Directory.systemTemp.createTemp('backup');
    store = SecureStore();
    service = BackupService(store, () async => directory);
    databaseFile = File('${directory.path}/xhandler.db');
    final key = await store.databaseKey(databaseExists: false);
    database = AppDatabase(openEncryptedDatabase(databaseFile, key));
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

  test('a backup restores the data and secrets with its password', () async {
    final oldDevice = await database.deviceId();
    final backup = await service.create(database, 'contraseña larga');
    // Nothing readable without the password
    expect(String.fromCharCodes(backup), isNot(contains('Empresa')));
    expect(String.fromCharCodes(backup), isNot(contains('clave sol')));

    // This device later loses everything...
    await store.replaceAllCompanySecrets({});
    final opened = await service.open(
      backup,
      password: 'contraseña larga',
      schemaVersion: database.schemaVersion,
    );
    expect(opened.secrets, {'company/c1/solPassword': 'clave sol'});

    await database.close();
    await service.install(opened, databaseFile);
    database = AppDatabase(
      openEncryptedDatabase(
        databaseFile,
        await store.databaseKey(databaseExists: true),
      ),
    );
    expect(
      (await database.select(database.companies).getSingle()).razonSocial,
      'Empresa',
    );
    expect((await store.readCompanySecrets('c1')).solPassword, 'clave sol');
    expect(opened.database.existsSync(), isFalse);
    // The restored phone is another device (docs/DESIGN.md §3.1)
    expect(await database.deviceId(), isNot(oldDevice));
  });

  test('a wrong password opens nothing', () async {
    final backup = await service.create(database, 'contraseña larga');
    await expectLater(
      service.open(backup, password: 'otra', schemaVersion: 3),
      throwsA(isA<WrongPasswordError>()),
    );
  });

  test('other files and newer versions are refused', () async {
    await expectLater(
      service.open(
        Uint8List.fromList('not a backup at all, really'.codeUnits),
        password: 'x',
        schemaVersion: 3,
      ),
      throwsA(isA<InvalidBackupError>()),
    );
    final backup = await service.create(database, 'contraseña larga');
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
}
