import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';

/// Series a new company starts with, all suggested for their document type:
/// (Catalog 1 document type, serie)
const defaultSeries = [
  ('01', 'F001'), // factura
  ('03', 'B001'), // boleta
  ('07', 'FC01'), // nota de crédito of a factura
  ('07', 'BC01'), // nota de crédito of a boleta
  ('08', 'FD01'), // nota de débito of a factura
  ('08', 'BD01'), // nota de débito of a boleta
  ('09', 'T001'), // guía de remisión remitente
  ('20', 'R001'), // retención
  ('40', 'P001'), // percepción
];

class SeriesRepository {
  SeriesRepository(this._db);

  final AppDatabase _db;

  Stream<List<Serie>> watchByCompany(String companyId) {
    final query = _db.select(_db.series)
      ..where((s) => s.companyId.equals(companyId) & s.deletedAt.isNull())
      ..orderBy([(s) => OrderingTerm(expression: s.tipoComprobante)])
      ..orderBy([(s) => OrderingTerm(expression: s.serie)]);
    return query.watch();
  }

  Future<void> save(SeriesCompanion serie) => _db
      .into(_db.series)
      .insertOnConflictUpdate(serie.copyWith(updatedAt: Value(DateTime.now())));

  /// Makes [serie] the suggested one of its document type. Notas de crédito
  /// and débito have one per affected document (F... for facturas, B... for
  /// boletas), so only series starting with the same letter are replaced.
  Future<void> setDefault(Serie serie) => _db.transaction(() async {
    final now = DateTime.now();
    await (_db.update(_db.series)..where(
          (s) =>
              s.companyId.equals(serie.companyId) &
              s.tipoComprobante.equals(serie.tipoComprobante) &
              s.serie.like('${serie.serie[0]}%'),
        ))
        .write(
          SeriesCompanion(isDefault: const Value(false), updatedAt: Value(now)),
        );
    await (_db.update(_db.series)..where((s) => s.id.equals(serie.id))).write(
      SeriesCompanion(isDefault: const Value(true), updatedAt: Value(now)),
    );
  });
}

final seriesRepositoryProvider = Provider(
  (ref) => SeriesRepository(ref.watch(databaseProvider)),
);
