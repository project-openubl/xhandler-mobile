import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../router.dart';
import '../../strings.dart';
import '../company/certificate_status.dart';

/// What a company in test mode still needs to issue real documents, with a
/// link to each step; collapsed so it doesn't hide the documents
class SetupChecklist extends ConsumerWidget {
  const SetupChecklist(this.company, {super.key});

  final Company company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certificate =
        ref.watch(savedCertificateProvider(company.id)).value != null;
    final credentials =
        ref.watch(hasSolCredentialsProvider(company.id)).value ?? false;
    // The last step is leaving test mode, where this isn't shown
    final steps = [certificate, credentials, false];
    return ExpansionTile(
      leading: const Icon(Icons.checklist),
      title: const Text(Strings.setupTitle),
      subtitle: Text(
        Strings.setupProgress(steps.where((done) => done).length, steps.length),
      ),
      children: [
        _Step(
          done: certificate,
          title: Strings.certificate,
          help: Strings.setupCertificateHelp,
          route: Routes.certificate,
        ),
        _Step(
          done: credentials,
          title: Strings.credentials,
          help: Strings.setupCredentialsHelp,
          route: Routes.credentials,
        ),
        const _Step(
          done: false,
          title: Strings.setupProduction,
          help: Strings.setupProductionHelp,
          route: Routes.companySettings,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.done,
    required this.title,
    required this.help,
    required this.route,
  });

  final bool done;
  final String title;
  final String help;
  final String route;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(done ? Icons.check_circle : Icons.radio_button_unchecked),
    title: Text(title),
    subtitle: Text(help),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => context.push(route),
  );
}
