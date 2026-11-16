import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';

import 'generated/schema.dart';

/// Every schema version upgrades to the current one as if created fresh.
/// After changing the tables, if the current version is still unpublished
/// (see `AppDatabase.schemaVersion`): `dart run drift_dev schema dump
/// lib/data/database.dart drift_schemas/app/` and `dart run drift_dev schema
/// generate drift_schemas/app/ test/data/generated/`. If it's published:
/// bump `schemaVersion` and add its `onUpgrade` step first.
void main() {
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  // The latest snapshot included: it must match the tables, so a forgotten
  // dump fails here
  for (final from in GeneratedHelper.versions) {
    test('upgrades from schema $from', () async {
      final connection = await verifier.startAt(from);
      final database = AppDatabase(connection);
      expect(database.schemaVersion, GeneratedHelper.versions.last);
      await verifier.migrateAndValidate(database, database.schemaVersion);
      await database.close();
    });
  }
}
