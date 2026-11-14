import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/secure_store.dart';
import '../series/series_repository.dart';

class CompanyRepository {
  CompanyRepository(this._db, this._secureStore);

  final AppDatabase _db;
  final SecureStore _secureStore;

  static const _activeCompanyKey = 'active_company_id';

  Stream<List<Company>> watchAll() {
    final query = _db.select(_db.companies)
      ..where((c) => c.deletedAt.isNull())
      ..orderBy([(c) => OrderingTerm(expression: c.razonSocial)]);
    return query.watch();
  }

  Future<Company?> find(String id) => (_db.select(
    _db.companies,
  )..where((c) => c.id.equals(id) & c.deletedAt.isNull())).getSingleOrNull();

  /// Adds the company with its [defaultSeries] and makes it the active one
  Future<String> create(CompaniesCompanion company) =>
      _db.transaction(() async {
        final created = await _db.into(_db.companies).insertReturning(company);
        for (final (tipoComprobante, serie) in defaultSeries) {
          await _db
              .into(_db.series)
              .insert(
                SeriesCompanion.insert(
                  companyId: created.id,
                  tipoComprobante: tipoComprobante,
                  serie: serie,
                  isDefault: const Value(true),
                ),
              );
        }
        await setActive(created.id);
        return created.id;
      });

  Future<void> update(CompaniesCompanion company) =>
      (_db.update(_db.companies)..where((c) => c.id.equals(company.id.value)))
          .write(company.copyWith(updatedAt: Value(DateTime.now())));

  /// Hides the company (soft delete, see docs/DESIGN.md §3.1) and deletes
  /// its secrets
  Future<void> delete(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.companies)..where((c) => c.id.equals(id))).write(
      CompaniesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    await _secureStore.deleteCompanySecrets(id);
  }

  /// The company the app works with, `null` before the first is created
  Stream<Company?> watchActive() {
    final query = _db.select(_db.companies).join([
      innerJoin(
        _db.deviceSettings,
        _db.deviceSettings.key.equals(_activeCompanyKey) &
            _db.deviceSettings.value.equalsExp(_db.companies.id),
      ),
    ])..where(_db.companies.deletedAt.isNull());
    return query.map((row) => row.readTable(_db.companies)).watchSingleOrNull();
  }

  Future<void> setActive(String id) => _db
      .into(_db.deviceSettings)
      .insertOnConflictUpdate(
        DeviceSettingsCompanion.insert(key: _activeCompanyKey, value: id),
      );

  Future<CompanySecrets> readSecrets(String id) =>
      _secureStore.readCompanySecrets(id);

  Future<void> writeSecrets(String id, CompanySecrets secrets) =>
      _secureStore.writeCompanySecrets(id, secrets);
}

final companyRepositoryProvider = Provider(
  (ref) => CompanyRepository(
    ref.watch(databaseProvider),
    ref.watch(secureStoreProvider),
  ),
);

final companiesProvider = StreamProvider(
  (ref) => ref.watch(companyRepositoryProvider).watchAll(),
);

final activeCompanyProvider = StreamProvider(
  (ref) => ref.watch(companyRepositoryProvider).watchActive(),
);
