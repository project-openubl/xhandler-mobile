import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/data/database.dart';

import 'generated/schema.dart';

/// Every schema version upgrades to the current one as if created fresh
/// (drift_schemas/app/: `dart run drift_dev schema dump ...` after a change)
void main() {
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  for (var from = 1; from < 4; from++) {
    test('upgrades from schema $from', () async {
      final connection = await verifier.startAt(from);
      final database = AppDatabase(connection);
      await verifier.migrateAndValidate(database, 4);
      await database.close();
    });
  }

  test('4: companies that used searchpe go back to no lookup', () async {
    final schema = await verifier.schemaAt(3);
    schema.rawDatabase.execute(
      'INSERT INTO companies '
      '(id, created_at, updated_at, ruc, razon_social, lookup_provider, '
      'lookup_url) VALUES '
      "('1', '2026-01-01T00:00:00.000Z', '2026-01-01T00:00:00.000Z', "
      "'20123456789', 'Empresa', 'searchpe', 'https://searchpe.example.com')",
    );
    final database = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(database, 4);

    final company = await database.select(database.companies).getSingle();
    expect(company.lookupProvider, LookupProvider.none);
    expect(company.razonSocial, 'Empresa');
    await database.close();
  });
}
