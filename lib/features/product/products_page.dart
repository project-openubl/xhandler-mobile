import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/search_list_page.dart';
import 'product_form_page.dart';
import 'product_repository.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage(this.company, {super.key});

  final Company company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void open([Product? product]) => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductFormPage(company, product: product),
      ),
    );

    return SearchListPage(
      title: Strings.products,
      addTooltip: Strings.newProduct,
      onAdd: open,
      list: (search) {
        final products =
            ref
                .watch(
                  productsProvider((companyId: company.id, search: search)),
                )
                .value ??
            const [];
        if (products.isEmpty) {
          return const Center(child: Text(Strings.noResults));
        }
        return ListView(
          children: [
            for (final product in products)
              ListTile(
                title: Text(product.descripcion),
                subtitle: Text(
                  '${company.moneda} ${product.precio} · '
                  '${Catalogs.unidadesMedida[product.unidadMedida] ?? product.unidadMedida}',
                ),
                trailing: IconButton(
                  tooltip: Strings.favorito,
                  icon: Icon(product.favorito ? Icons.star : Icons.star_border),
                  onPressed: () => ref
                      .read(productRepositoryProvider)
                      .update(
                        product.id,
                        ProductsCompanion(favorito: Value(!product.favorito)),
                      ),
                ),
                onTap: () => open(product),
              ),
          ],
        );
      },
    );
  }
}
