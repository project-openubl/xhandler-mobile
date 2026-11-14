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

  Stream<List<Company>> watchAll() => _companies().watch();

  SimpleSelectStatement<$CompaniesTable, Company> _companies() =>
      _db.select(_db.companies)
        ..where((c) => c.deletedAt.isNull())
        ..orderBy([(c) => OrderingTerm(expression: c.razonSocial)]);

  Future<Company?> findByRuc(String ruc) => (_db.select(
    _db.companies,
  )..where((c) => c.ruc.equals(ruc) & c.deletedAt.isNull())).getSingleOrNull();

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

  Future<void> update(String id, CompaniesCompanion changes) =>
      _db.updateRow(_db.companies, id, changes);

  /// Hides the company (DESIGN §3.1), activates another one if it was the
  /// active one, and deletes its secrets
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.softDelete(_db.companies, id);
      final active = await (_db.select(
        _db.deviceSettings,
      )..where((s) => s.key.equals(_activeCompanyKey))).getSingleOrNull();
      if (active?.value != id) return;
      final remaining = await _companies().get();
      if (remaining.isEmpty) {
        await (_db.delete(
          _db.deviceSettings,
        )..where((s) => s.key.equals(_activeCompanyKey))).go();
      } else {
        await setActive(remaining.first.id);
      }
    });
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

  /// See [SecureStore.writeCompanySecrets]
  Future<void> writeSecrets(String id, Map<CompanySecret, String?> secrets) =>
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
