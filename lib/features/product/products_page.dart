import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../amount_text.dart';
import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/search_list_page.dart';
import 'product_form_page.dart';
import 'product_repository.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage(this.company, {super.key});

  final Company company;

  @override
  Widget build(BuildContext context) {
    void open([Product? product]) => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductFormPage(company, product: product),
      ),
    );

    return SearchListPage(
      title: Strings.products,
      addTooltip: Strings.newProduct,
      onAdd: open,
      list: (search) => ProductList(company, search: search, onTap: open),
    );
  }
}

/// The company's products matching [search], favorites first
class ProductList extends ConsumerWidget {
  const ProductList(
    this.company, {
    super.key,
    required this.search,
    required this.onTap,
    this.showFavorite = true,
    this.controller,
  });

  final Company company;
  final String search;
  final ValueChanged<Product> onTap;

  /// Star to mark favorites (the catalog page, not the pickers)
  final bool showFavorite;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      productsProvider((companyId: company.id, search: search)),
    );
    return switch (products) {
      AsyncData(value: []) => const Center(child: Text(Strings.noResults)),
      AsyncData(:final value) => ListView(
        controller: controller,
        children: [
          for (final product in value)
            ListTile(
              title: Text(product.descripcion),
              subtitle: Text(
                '${formatMoney(company.moneda, product.precio)} · '
                '${Catalogs.unidadesMedida[product.unidadMedida] ?? product.unidadMedida}',
              ),
              trailing: showFavorite
                  ? IconButton(
                      tooltip: Strings.favorito,
                      icon: Icon(
                        product.favorito ? Icons.star : Icons.star_border,
                      ),
                      onPressed: () => ref
                          .read(productRepositoryProvider)
                          .update(
                            product.id,
                            ProductsCompanion(
                              favorito: Value(!product.favorito),
                            ),
                          ),
                    )
                  : null,
              onTap: () => onTap(product),
            ),
        ],
      ),
      AsyncError() => const Center(child: Text(Strings.unexpectedError)),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
