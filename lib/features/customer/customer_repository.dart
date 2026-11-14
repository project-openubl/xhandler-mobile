import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';

class CustomerRepository {
  CustomerRepository(this._db);

  final AppDatabase _db;

  /// Customers of the company whose name or document number contain [search]
  Stream<List<Customer>> watch(String companyId, {String search = ''}) {
    final query = _db.select(_db.customers)
      ..where(
        (c) =>
            c.companyId.equals(companyId) &
            c.deletedAt.isNull() &
            (c.nombre.contains(search) |
                c.numeroDocumentoIdentidad.contains(search)),
      )
      ..orderBy([(c) => OrderingTerm(expression: c.nombre)]);
    return query.watch();
  }

  Future<Customer?> findByDocument(
    String companyId,
    String tipoDocumentoIdentidad,
    String numeroDocumentoIdentidad,
  ) {
    final query = _db.select(_db.customers)
      ..where(
        (c) =>
            c.companyId.equals(companyId) &
            c.deletedAt.isNull() &
            c.tipoDocumentoIdentidad.equals(tipoDocumentoIdentidad) &
            c.numeroDocumentoIdentidad.equals(numeroDocumentoIdentidad),
      );
    return query.getSingleOrNull();
  }

  Future<void> save(CustomersCompanion customer) => _db
      .into(_db.customers)
      .insertOnConflictUpdate(
        customer.copyWith(updatedAt: Value(DateTime.now())),
      );

  Future<void> delete(String id) {
    final now = DateTime.now();
    return (_db.update(_db.customers)..where((c) => c.id.equals(id))).write(
      CustomersCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }
}

final customerRepositoryProvider = Provider(
  (ref) => CustomerRepository(ref.watch(databaseProvider)),
);
