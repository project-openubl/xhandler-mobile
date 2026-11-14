import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../router.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'company_repository.dart';

/// Settings of the active company
class CompanySettingsPage extends ConsumerWidget {
  const CompanySettingsPage(this.company, {super.key});

  final Company company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testMode = company.sunatEnvironment == SunatEnvironment.beta;
    final error = Theme.of(context).colorScheme.error;
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
          ListTile(
            leading: const Icon(Icons.travel_explore),
            title: const Text(Strings.lookupSettings),
            onTap: () => context.push(Routes.lookupSettings),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.science),
            title: const Text(Strings.testModeSwitch),
            subtitle: const Text(Strings.testModeHelp),
            value: testMode,
            onChanged: (beta) => _setTestMode(context, ref, beta),
          ),
          if (testMode)
            ListTile(
              leading: const Icon(Icons.health_and_safety),
              title: const Text(Strings.sunatBetaCheckTitle),
              onTap: () => context.push(Routes.diagnostics),
            ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.delete, color: error),
            title: Text(Strings.deleteCompany, style: TextStyle(color: error)),
            onTap: () => _delete(context, ref),
          ),
        ],
      ),
    );
  }

  /// Leaving test mode needs the certificate and SOL credentials, and the
  /// user's confirmation: documents become real.
  // TODO(phase 3): archive the beta documents and reset the series (DESIGN §1)
  Future<void> _setTestMode(
    BuildContext context,
    WidgetRef ref,
    bool beta,
  ) async {
    final repository = ref.read(companyRepositoryProvider);
    if (!beta) {
      final secrets = await repository.readSecrets(company.id);
      if (!context.mounted) return;
      if (secrets.certificate == null ||
          secrets.solUsername == null ||
          secrets.solPassword == null) {
        showMessage(context, Strings.productionMissing);
        return;
      }
      if (!await confirm(
        context,
        message: Strings.productionConfirm,
        accept: Strings.productionAccept,
      )) {
        return;
      }
    }
    await repository.update(
      company.id,
      CompaniesCompanion(
        sunatEnvironment: Value(
          beta ? SunatEnvironment.beta : SunatEnvironment.production,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(companyRepositoryProvider);
    if (!await confirm(
      context,
      title: company.razonSocial,
      message: Strings.deleteCompanyConfirm,
      accept: Strings.delete,
    )) {
      return;
    }
    await repository.delete(company.id);
    if (context.mounted) context.go(Routes.home);
  }
}
