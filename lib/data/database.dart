import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import '../src/rust/api/sunat.dart';
import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Companies, Series, Customers, Products, DeviceSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );
}

/// Opens the app's database file, encrypted with [key] (hex)
AppDatabase openAppDatabase(String key) {
  return AppDatabase(
    LazyDatabase(() async {
      final directory = await getApplicationSupportDirectory();
      return openEncryptedDatabase(File('${directory.path}/xhandler.db'), key);
    }),
  );
}

/// SQLite3MultipleCiphers database file encrypted with [key] (hex)
QueryExecutor openEncryptedDatabase(File file, String key) {
  if (!RegExp(r'^[0-9a-f]+$').hasMatch(key)) {
    throw ArgumentError('The database key must be hex');
  }
  return NativeDatabase.createInBackground(
    file,
    setup: (database) => database.execute("PRAGMA key = '$key'"),
  );
}
