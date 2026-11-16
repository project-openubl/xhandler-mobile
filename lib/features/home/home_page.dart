import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../router.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/test_mode_banner.dart';
import '../backup/backup_page.dart';
import '../company/certificate_status.dart';
import '../company/company_repository.dart';
import '../despatch/despatch_advice_form_page.dart';
import '../document/documents_list.dart';
import '../document/invoice_form_page.dart';
import '../document/perception_retention_form_page.dart';
import '../document/quick_sale_page.dart';
import 'setup_checklist.dart';

/// The active company's home, or a welcome page before the first company
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(activeCompanyProvider)) {
      AsyncData(value: final company?) => _CompanyHome(company),
      AsyncData() => const _WelcomePage(),
      AsyncError() => Scaffold(
        body: ErrorRetry(onRetry: () => ref.invalidate(activeCompanyProvider)),
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
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, _) => OutlinedButton(
                  onPressed: () => restoreBackup(context, ref),
                  child: const Text(Strings.restoreBackup),
                ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          builder: (sheetContext) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.point_of_sale),
                  title: const Text(Strings.quickSale),
                  subtitle: const Text(Strings.quickSaleHelp),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => QuickSalePage(company),
                      ),
                    );
                  },
                ),
                for (final (tipo, icon, title, help) in const [
                  (
                    '03',
                    Icons.receipt_long,
                    Strings.boleta,
                    Strings.boletaHelp,
                  ),
                  (
                    '01',
                    Icons.request_quote,
                    Strings.factura,
                    Strings.facturaHelp,
                  ),
                ])
                  ListTile(
                    leading: Icon(icon),
                    title: Text(title),
                    subtitle: Text(help),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _newDocument(context, tipo);
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.local_shipping),
                  title: const Text(Strings.guia),
                  subtitle: const Text(Strings.guiaHelp),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DespatchAdviceFormPage(company),
                      ),
                    );
                  },
                ),
                for (final (tipo, title, help) in [
                  if (company.esAgentePercepcion)
                    ('40', Strings.percepcion, Strings.percepcionHelp),
                  if (company.esAgenteRetencion)
                    ('20', Strings.retencion, Strings.retencionHelp),
                ])
                  ListTile(
                    leading: const Icon(Icons.percent),
                    title: Text(title),
                    subtitle: Text(help),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => PerceptionRetentionFormPage(
                            company,
                            tipoComprobante: tipo,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text(Strings.newDocument),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (company.sunatEnvironment == SunatEnvironment.beta) ...[
            const TestModeBanner(),
            SetupChecklist(company),
          ],
          CertificateWarningBanner(company.id),
          Expanded(child: DocumentsList(company)),
        ],
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
      unawaited(router.push(route));
    }

    return NavigationDrawer(
      children: [
        for (final company in companies)
          ListTile(
            leading: const Icon(Icons.business),
            title: Text(company.razonSocial),
            subtitle: Text(company.ruc),
            selected: company.id == activeId,
            onTap: () async {
              Scaffold.of(context).closeDrawer();
              await ref.read(companyRepositoryProvider).setActive(company.id);
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
        ListTile(
          leading: const Icon(Icons.bar_chart),
          title: const Text(Strings.reports),
          onTap: () => open(Routes.reports),
        ),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text(Strings.backupTitle),
          onTap: () => open(Routes.backup),
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text(Strings.security),
          onTap: () => open(Routes.security),
        ),
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text(Strings.appearance),
          onTap: () => open(Routes.appearance),
        ),
      ],
    );
  }
}
