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
            (containsText(c.nombre, search) |
                containsText(c.numeroDocumentoIdentidad, search)),
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

  Future<void> create(CustomersCompanion customer) =>
      _db.into(_db.customers).insert(customer);

  Future<void> update(String id, CustomersCompanion changes) =>
      _db.updateRow(_db.customers, id, changes);

  Future<void> delete(String id) => _db.softDelete(_db.customers, id);
}

final customerRepositoryProvider = Provider(
  (ref) => CustomerRepository(ref.watch(databaseProvider)),
);

final customersProvider = StreamProvider.autoDispose
    .family<List<Customer>, ({String companyId, String search})>(
      (ref, query) => ref
          .watch(customerRepositoryProvider)
          .watch(query.companyId, search: query.search),
    );
