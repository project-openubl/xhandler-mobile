import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../router.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import 'company_repository.dart';

/// Settings of the active company
class CompanySettingsPage extends ConsumerWidget {
  const CompanySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(activeCompanyProvider).value;
    if (company == null) return const Scaffold();
    final repository = ref.read(companyRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(company.razonSocial)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text(Strings.companyData),
            subtitle: Text(company.ruc),
            onTap: () => context.push(Routes.editCompany),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text(Strings.certificate),
            onTap: () => context.push(Routes.certificate),
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text(Strings.credentials),
            onTap: () => context.push(Routes.credentials),
          ),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text(Strings.series),
            onTap: () => context.push(Routes.series),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.science),
            title: const Text(Strings.testModeSwitch),
            subtitle: const Text(Strings.testModeHelp),
            value: company.sunatEnvironment == SunatEnvironment.beta,
            onChanged: (beta) => repository.update(
              company.id,
              CompaniesCompanion(
                sunatEnvironment: Value(
                  beta ? SunatEnvironment.beta : SunatEnvironment.production,
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text(Strings.deleteCompany),
            onTap: () => _delete(context, ref, company),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Company company,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(company.razonSocial),
        content: const Text(Strings.deleteCompanyConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(Strings.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(companyRepositoryProvider).delete(company.id);
    if (context.mounted) context.go(Routes.home);
  }
}
