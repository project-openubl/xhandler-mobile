import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/search_list_page.dart';
import 'customer_form_page.dart';
import 'customer_repository.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage(this.company, {super.key});

  final Company company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void open([Customer? customer]) => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CustomerFormPage(company, customer: customer),
      ),
    );

    return SearchListPage(
      title: Strings.customers,
      addTooltip: Strings.newCustomer,
      onAdd: open,
      list: (search) {
        final customers =
            ref
                .watch(
                  customersProvider((companyId: company.id, search: search)),
                )
                .value ??
            const [];
        if (customers.isEmpty) {
          return const Center(child: Text(Strings.noResults));
        }
        return ListView(
          children: [
            for (final customer in customers)
              ListTile(
                title: Text(customer.nombre),
                subtitle: Text(
                  '${Catalogs.tiposDocumentoIdentidad[customer.tipoDocumentoIdentidad] ?? customer.tipoDocumentoIdentidad}'
                  ' ${customer.numeroDocumentoIdentidad}',
                ),
                onTap: () => open(customer),
              ),
          ],
        );
      },
    );
  }
}
