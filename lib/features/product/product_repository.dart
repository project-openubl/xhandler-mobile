import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';

class ProductRepository {
  ProductRepository(this._db);

  final AppDatabase _db;

  /// Products of the company whose description or code contain [search];
  /// favorites first
  Stream<List<Product>> watch(String companyId, {String search = ''}) {
    final query = _db.select(_db.products)
      ..where(
        (p) =>
            p.companyId.equals(companyId) &
            p.deletedAt.isNull() &
            (p.descripcion.contains(search) | p.codigo.contains(search)),
      )
      ..orderBy([
        (p) => OrderingTerm.desc(p.favorito),
        (p) => OrderingTerm(expression: p.descripcion),
      ]);
    return query.watch();
  }

  Future<void> save(ProductsCompanion product) => _db
      .into(_db.products)
      .insertOnConflictUpdate(
        product.copyWith(updatedAt: Value(DateTime.now())),
      );

  Future<void> delete(String id) {
    final now = DateTime.now();
    return (_db.update(_db.products)..where((p) => p.id.equals(id))).write(
      ProductsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }
}

final productRepositoryProvider = Provider(
  (ref) => ProductRepository(ref.watch(databaseProvider)),
);
