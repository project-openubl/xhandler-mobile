import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/data/secure_store.dart';
import 'package:xhandler_mobile/src/rust/api/sunat.dart';

void main() {
  late Directory directory;
  late File file;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('xhandler');
    file = File('${directory.path}/test.db');
  });
  tearDown(() => directory.delete(recursive: true));

  Future<void> writeSecret(String key) async {
    final database = AppDatabase(openEncryptedDatabase(file, key));
    await database
        .into(database.deviceSettings)
        .insert(DeviceSettingsCompanion.insert(key: 'k', value: 'secret'));
    await database.close();
  }

  test('the database file is encrypted with its key', () async {
    await writeSecret('ab12');

    expect(
      await file.readAsString(encoding: latin1),
      isNot(contains('secret')),
    );

    final reopened = AppDatabase(openEncryptedDatabase(file, 'ab12'));
    expect(await reopened.select(reopened.deviceSettings).get(), hasLength(1));
    await reopened.close();

    final wrongKey = AppDatabase(openEncryptedDatabase(file, 'cd34'));
    await expectLater(
      wrongKey.customSelect('SELECT count(*) FROM sqlite_master').get(),
      throwsA(isA<Exception>().having((e) => '$e', 'message', contains('26'))),
    );
    await wrongKey.close();
  });

  test('checkKeyOpens tells a wrong key apart', () async {
    checkKeyOpens(file, 'ab12'); // no file yet
    await writeSecret('ab12');

    checkKeyOpens(file, 'ab12');
    expect(
      () => checkKeyOpens(file, 'cd34'),
      throwsA(
        isA<SqliteException>().having(
          (e) => e.extendedResultCode,
          'code',
          sqliteNotADatabase,
        ),
      ),
    );
  });

  test('VACUUM INTO keeps the snapshot encrypted with the same key', () async {
    await writeSecret('ab12');
    final snapshot = File('${directory.path}/snapshot.db');
    final database = AppDatabase(openEncryptedDatabase(file, 'ab12'));
    await database.customStatement("VACUUM INTO '${snapshot.path}'");
    await database.close();

    expect(
      await snapshot.readAsString(encoding: latin1),
      isNot(contains('secret')),
    );
    final restored = AppDatabase(openEncryptedDatabase(snapshot, 'ab12'));
    expect(await restored.select(restored.deviceSettings).get(), hasLength(1));
    await restored.close();
  });

  test('keys must be hex, as they go into a PRAGMA', () {
    expect(
      () => openEncryptedDatabase(File('unused.db'), "x'; DROP"),
      throwsArgumentError,
    );
  });

  test('timestamps are stored in UTC with milliseconds', () async {
    final database = AppDatabase(openEncryptedDatabase(file, 'ab12'));
    final company = await database
        .into(database.companies)
        .insertReturning(
          CompaniesCompanion.insert(ruc: '20123456789', razonSocial: 'A'),
        );
    final stored = await database
        .customSelect('SELECT created_at FROM companies')
        .getSingle();
    await database.close();

    expect(company.createdAt.isUtc, isTrue);
    expect(stored.read<String>('created_at'), matches(r'\.\d+Z$'));
  });

  test('device settings are read, replaced and deleted by key', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    expect(await database.setting('k'), isNull);
    await database.setSetting('k', 'a');
    await database.setSetting('k', 'b');
    expect(await database.setting('k'), 'b');
    await database.deleteSetting('k');
    expect(await database.setting('k'), isNull);
  });

  test('stored SUNAT environments keep their names', () {
    // Companies store the bridge enum by name: renaming a variant in Rust
    // would make existing rows unreadable
    expect(SunatEnvironment.values.map((e) => e.name), ['beta', 'production']);
  });

  group('SecureStore.databaseKey', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('a fresh install gets a new key and loses leftovers', () async {
      final store = SecureStore();
      await store.writeCompanySecrets('old', {CompanySecret.solUsername: 'x'});

      final key = await store.databaseKey(databaseExists: false);

      expect(key, matches(r'^[0-9a-f]{64}$'));
      expect(await store.databaseKey(databaseExists: true), key);
      expect((await store.readCompanySecrets('old')).solUsername, isNull);
    });

    test('an existing database without its key is reported', () {
      expect(
        SecureStore().databaseKey(databaseExists: true),
        throwsA(isA<DatabaseKeyLostError>()),
      );
    });
  });
}
