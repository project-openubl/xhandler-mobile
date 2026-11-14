import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';

import 'generated/schema.dart';

/// Every schema version upgrades to the current one as if created fresh
/// (drift_schemas/: `dart run drift_dev schema dump ...` after a change)
void main() {
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  for (var from = 1; from < 3; from++) {
    test('upgrades from schema $from', () async {
      final connection = await verifier.startAt(from);
      final database = AppDatabase(connection);
      await verifier.migrateAndValidate(database, 3);
      await database.close();
    });
  }
}
