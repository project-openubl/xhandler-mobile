import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';

void main() {
  test('the database file is encrypted with its key', () async {
    final directory = await Directory.systemTemp.createTemp('xhandler');
    final file = File('${directory.path}/test.db');
    addTearDown(() => directory.delete(recursive: true));

    final database = AppDatabase(openEncryptedDatabase(file, 'ab12'));
    await database
        .into(database.deviceSettings)
        .insert(DeviceSettingsCompanion.insert(key: 'k', value: 'secret'));
    await database.close();

    expect(
      await file.readAsString(encoding: latin1),
      isNot(contains('secret')),
    );

    final reopened = AppDatabase(openEncryptedDatabase(file, 'ab12'));
    expect(await reopened.select(reopened.deviceSettings).get(), hasLength(1));
    await reopened.close();

    final wrongKey = AppDatabase(openEncryptedDatabase(file, 'cd34'));
    await expectLater(
      wrongKey.select(wrongKey.deviceSettings).get(),
      throwsA(anything),
    );
    await wrongKey.close();
  });

  test('keys must be hex, as they go into a PRAGMA', () {
    expect(
      () => openEncryptedDatabase(File('unused.db'), "x'; DROP"),
      throwsArgumentError,
    );
  });
}
