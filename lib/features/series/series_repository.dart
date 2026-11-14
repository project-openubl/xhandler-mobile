import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';
import '../../src/rust/api/sunat.dart';

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
      ..where((s) => s.companyId.equals(companyId))
      ..orderBy([
        (s) => OrderingTerm(expression: s.tipoComprobante),
        (s) => OrderingTerm(expression: s.serie),
      ]);
    return query.watch();
  }

  Future<bool> exists(
    String companyId,
    String tipoComprobante,
    String serie,
  ) async {
    final query = _db.select(_db.series)
      ..where(
        (s) =>
            s.companyId.equals(companyId) &
            s.tipoComprobante.equals(tipoComprobante) &
            s.serie.equals(serie),
      );
    return await query.getSingleOrNull() != null;
  }

  Future<void> create(SeriesCompanion serie) =>
      _db.into(_db.series).insert(serie);

  Future<void> update(String id, SeriesCompanion changes) =>
      _db.updateRow(_db.series, id, changes);

  /// After switching environment (test mode ↔ production), each serie
  /// continues from the last number issued in [environment], 1 when none
  Future<void> resetNumbers(String companyId, SunatEnvironment environment) =>
      _db.transaction(() async {
        final series = await (_db.select(
          _db.series,
        )..where((s) => s.companyId.equals(companyId))).get();
        for (final serie in series) {
          final last = _db.documents.numero.max();
          final query = _db.selectOnly(_db.documents)
            ..addColumns([last])
            ..where(
              _db.documents.companyId.equals(companyId) &
                  _db.documents.environment.equalsValue(environment) &
                  _db.documents.tipoComprobante.equals(serie.tipoComprobante) &
                  _db.documents.serie.equals(serie.serie),
            );
          final lastNumero =
              await query.map((row) => row.read(last)).getSingle() ?? 0;
          await update(
            serie.id,
            SeriesCompanion(nextNumber: Value(lastNumero + 1)),
          );
        }
      });

  /// Makes [serie] the suggested one of its document type. Notas de crédito
  /// and débito have one per affected document (F... for facturas, B... for
  /// boletas), so only series starting with the same letter are replaced;
  /// the other types have a single kind.
  Future<void> setDefault(Serie serie) => _db.transaction(() async {
    final sameKind =
        await (_db.select(_db.series)..where(
              (s) =>
                  s.companyId.equals(serie.companyId) &
                  s.tipoComprobante.equals(serie.tipoComprobante) &
                  s.serie.like('${serie.serie[0]}%'),
            ))
            .get();
    for (final other in sameKind) {
      await update(
        other.id,
        SeriesCompanion(isDefault: Value(other.id == serie.id)),
      );
    }
  });
}

final seriesRepositoryProvider = Provider(
  (ref) => SeriesRepository(ref.watch(databaseProvider)),
);

final seriesProvider = StreamProvider.autoDispose.family<List<Serie>, String>(
  (ref, companyId) =>
      ref.watch(seriesRepositoryProvider).watchByCompany(companyId),
);
