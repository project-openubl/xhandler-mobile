import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

import '../src/rust/api/sunat.dart';
import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Companies,
    Series,
    Customers,
    Products,
    Documents,
    DocumentFiles,
    DocumentEvents,
    DeviceSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  /// Updates a row that isn't deleted and stamps `updated_at`. `id` and
  /// `deleted_at` in [changes] are ignored.
  Future<void> updateRow<T extends SyncColumns, D>(
    TableInfo<T, D> table,
    String id,
    Insertable<D> changes,
  ) {
    final columns = {
      ...changes.toColumns(false),
      'updated_at': Variable(nowUtc()),
    }..removeWhere((name, _) => name == 'id' || name == 'deleted_at');
    final query = update(table)
      ..where((row) => row.id.equals(id) & row.deletedAt.isNull());
    return query.write(RawValuesInsertable(columns));
  }

  /// Id of this installation, generated once (DESIGN §3.1)
  Future<String> deviceId() => transaction(() async {
    const key = 'device_id';
    final existing = await (select(
      deviceSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    if (existing != null) return existing.value;
    final id = newId();
    await into(deviceSettings)
        .insert(DeviceSettingsCompanion.insert(key: key, value: id));
    return id;
  });

  /// Hides the row (DESIGN §3.1: deletions must be replicable)
  Future<void> softDelete<T extends SyncColumns, D>(
    TableInfo<T, D> table,
    String id,
  ) {
    final now = Variable(nowUtc());
    final query = update(table)..where((row) => row.id.equals(id));
    return query.write(
      RawValuesInsertable({'deleted_at': now, 'updated_at': now}),
    );
  }
}

/// SQLite3MultipleCiphers database file encrypted with [key] (hex)
QueryExecutor openEncryptedDatabase(File file, String key) {
  if (!RegExp(r'^[0-9a-f]+$').hasMatch(key)) {
    throw ArgumentError('The database key must be hex');
  }
  return NativeDatabase.createInBackground(
    file,
    setup: (database) => database
      ..execute("PRAGMA key = '$key'")
      ..execute('PRAGMA foreign_keys = ON'),
  );
}

/// SQLITE_NOTADB, the error of a key that doesn't decrypt the file
const sqliteNotADatabase = 26;

/// Throws a [SqliteException] with [sqliteNotADatabase] if [key] doesn't
/// open [file]. Runs synchronously, before Drift opens the database.
void checkKeyOpens(File file, String key) {
  if (!file.existsSync()) return;
  final database = sqlite3.open(file.path);
  try {
    database
      ..execute("PRAGMA key = '$key'")
      ..select('SELECT count(*) FROM sqlite_master');
  } finally {
    database.close();
  }
}

/// `column LIKE '%text%'`, with `%` and `_` in [text] taken literally
Expression<bool> containsText(Expression<String> column, String text) {
  final escaped = text.replaceAllMapped(
    RegExp(r'[\\%_]'),
    (match) => '\\${match[0]}',
  );
  return column.like('%$escaped%', escapeChar: r'\');
}
