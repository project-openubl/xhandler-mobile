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
      list: (search) => _CustomerList(company, search, onTap: open),
    );
  }
}

class _CustomerList extends ConsumerWidget {
  const _CustomerList(this.company, this.search, {required this.onTap});

  final Company company;
  final String search;
  final ValueChanged<Customer> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(
      customersProvider((companyId: company.id, search: search)),
    );
    return switch (customers) {
      AsyncData(value: []) => const Center(child: Text(Strings.noResults)),
      AsyncData(:final value) => ListView(
        children: [
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
      ),
      AsyncError() => const Center(child: Text(Strings.unexpectedError)),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
