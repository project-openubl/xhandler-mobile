import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../router.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../company/company_repository.dart';
import '../document/documents_list.dart';
import '../document/invoice_form_page.dart';

/// The active company's home, or a welcome page before the first company
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(activeCompanyProvider)) {
      AsyncData(value: final company?) => _CompanyHome(company),
      AsyncData() => const _WelcomePage(),
      AsyncError() => const Scaffold(
        body: Center(child: Text(Strings.unexpectedError)),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                Strings.welcomeTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              const Text(Strings.welcomeText),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => context.push(Routes.newCompany),
                child: const Text(Strings.createCompany),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyHome extends StatelessWidget {
  const _CompanyHome(this.company);

  final Company company;

  void _newDocument(BuildContext context, String tipoComprobante) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              InvoiceFormPage(company, tipoComprobante: tipoComprobante),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company.nombreComercial ?? company.razonSocial),
      ),
      drawer: _CompanyDrawer(activeId: company.id),
      floatingActionButton: MenuAnchor(
        menuChildren: [
          MenuItemButton(
            leadingIcon: const Icon(Icons.receipt_long),
            onPressed: () => _newDocument(context, '03'),
            child: const Text(Strings.boleta),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.request_quote),
            onPressed: () => _newDocument(context, '01'),
            child: const Text(Strings.factura),
          ),
        ],
        builder: (context, menu, _) => FloatingActionButton.extended(
          onPressed: () => menu.isOpen ? menu.close() : menu.open(),
          icon: const Icon(Icons.add),
          label: const Text(Strings.newDocument),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (company.sunatEnvironment == SunatEnvironment.beta)
            const TestModeBanner(),
          Expanded(child: DocumentsList(company)),
        ],
      ),
    );
  }
}

/// Reminds that documents go to SUNAT beta
class TestModeBanner extends StatelessWidget {
  const TestModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          Strings.testMode,
          style: TextStyle(color: colors.onTertiaryContainer),
        ),
      ),
    );
  }
}

/// Switches between companies and opens the company's pages
class _CompanyDrawer extends ConsumerWidget {
  const _CompanyDrawer({required this.activeId});

  final String activeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(companiesProvider).value ?? const [];
    final router = GoRouter.of(context);
    void open(String route) {
      Scaffold.of(context).closeDrawer();
      router.push(route);
    }

    return NavigationDrawer(
      children: [
        for (final company in companies)
          ListTile(
            leading: const Icon(Icons.business),
            title: Text(company.razonSocial),
            subtitle: Text(company.ruc),
            selected: company.id == activeId,
            onTap: () {
              ref.read(companyRepositoryProvider).setActive(company.id);
              Scaffold.of(context).closeDrawer();
            },
          ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text(Strings.addCompany),
          onTap: () => open(Routes.newCompany),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text(Strings.customers),
          onTap: () => open(Routes.customers),
        ),
        ListTile(
          leading: const Icon(Icons.inventory_2),
          title: const Text(Strings.products),
          onTap: () => open(Routes.products),
        ),
        ListTile(
          leading: const Icon(Icons.numbers),
          title: const Text(Strings.series),
          onTap: () => open(Routes.series),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text(Strings.companySettings),
          onTap: () => open(Routes.companySettings),
        ),
      ],
    );
  }
}
