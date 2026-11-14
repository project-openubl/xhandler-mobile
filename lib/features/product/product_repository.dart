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
            (containsText(p.descripcion, search) |
                containsText(p.codigo, search)),
      )
      ..orderBy([
        (p) => OrderingTerm.desc(p.favorito),
        (p) => OrderingTerm(expression: p.descripcion),
      ]);
    return query.watch();
  }

  /// Favorites of the company, for quick sale
  Stream<List<Product>> watchFavorites(String companyId) {
    final query = _db.select(_db.products)
      ..where(
        (p) =>
            p.companyId.equals(companyId) &
            p.deletedAt.isNull() &
            p.favorito.equals(true),
      )
      ..orderBy([(p) => OrderingTerm(expression: p.descripcion)]);
    return query.watch();
  }

  Future<void> create(ProductsCompanion product) =>
      _db.into(_db.products).insert(product);

  Future<void> update(String id, ProductsCompanion changes) =>
      _db.updateRow(_db.products, id, changes);

  Future<void> delete(String id) => _db.softDelete(_db.products, id);
}

final productRepositoryProvider = Provider(
  (ref) => ProductRepository(ref.watch(databaseProvider)),
);

final productsProvider = StreamProvider.autoDispose
    .family<List<Product>, ({String companyId, String search})>(
      (ref, query) => ref
          .watch(productRepositoryProvider)
          .watch(query.companyId, search: query.search),
    );

final favoriteProductsProvider = StreamProvider.autoDispose
    .family<List<Product>, String>(
      (ref, companyId) =>
          ref.watch(productRepositoryProvider).watchFavorites(companyId),
    );
