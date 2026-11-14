import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/search_list_page.dart';
import 'customer_form_page.dart';
import 'customer_repository.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage(this.company, {super.key});

  final Company company;

  @override
  Widget build(BuildContext context) {
    void open([Customer? customer]) => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CustomerFormPage(company, customer: customer),
      ),
    );

    return SearchListPage(
      title: Strings.customers,
      addTooltip: Strings.newCustomer,
      onAdd: open,
      list: (search) => CustomerList(company, search: search, onTap: open),
    );
  }
}

/// The company's customers matching [search]
class CustomerList extends ConsumerWidget {
  const CustomerList(
    this.company, {
    super.key,
    required this.search,
    required this.onTap,
    this.onlyRuc = false,
    this.leading = const [],
    this.controller,
  });

  final Company company;
  final String search;
  final ValueChanged<Customer> onTap;

  /// Only customers with a RUC (facturas)
  final bool onlyRuc;

  /// Entries shown above the customers
  final List<Widget> leading;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(
      customersProvider((companyId: company.id, search: search)),
    );
    final value = customers.value
        ?.where((c) => !onlyRuc || c.tipoDocumentoIdentidad == '6')
        .toList();
    return ListView(
      controller: controller,
      children: [
        ...leading,
        if (value == null)
          const Center(child: CircularProgressIndicator())
        else if (value.isEmpty)
          const ListTile(title: Text(Strings.noResults))
        else
          for (final customer in value)
            ListTile(
              title: Text(customer.nombre),
              subtitle: Text(
                '${Catalogs.tiposDocumentoIdentidad[customer.tipoDocumentoIdentidad] ?? customer.tipoDocumentoIdentidad}'
                ' ${customer.numeroDocumentoIdentidad}',
              ),
              onTap: () => onTap(customer),
            ),
      ],
    );
  }
}
