import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/secure_store.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'company_repository.dart';

/// SOL user and the API client for guías de remisión, kept in secure storage
class CredentialsPage extends ConsumerStatefulWidget {
  const CredentialsPage({super.key});

  @override
  ConsumerState<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends ConsumerState<CredentialsPage> {
  late final _company = ref.read(activeCompanyProvider).value!;
  final _solUsername = TextEditingController();
  final _solPassword = TextEditingController();
  final _greClientId = TextEditingController();
  final _greClientSecret = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final secrets = await ref
        .read(companyRepositoryProvider)
        .readSecrets(_company.id);
    _solUsername.text = secrets.solUsername ?? '';
    _solPassword.text = secrets.solPassword ?? '';
    _greClientId.text = secrets.greClientId ?? '';
    _greClientSecret.text = secrets.greClientSecret ?? '';
  }

  @override
  void dispose() {
    for (final controller in [
      _solUsername,
      _solPassword,
      _greClientId,
      _greClientSecret,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(companyRepositoryProvider).writeSecrets(_company.id, {
      CompanySecret.solUsername: optionalText(_solUsername),
      CompanySecret.solPassword: optionalText(_solPassword),
      CompanySecret.greClientId: optionalText(_greClientId),
      CompanySecret.greClientSecret: optionalText(_greClientSecret),
    });
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.credentials),
        actions: [
          TextButton(onPressed: _save, child: const Text(Strings.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_company.sunatEnvironment == SunatEnvironment.beta)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(Strings.credentialsTestModeHelp),
            ),
          FormTextField(
            _solUsername,
            Strings.solUsername,
            helperText: Strings.solUsernameHelp,
          ),
          FormTextField(_solPassword, Strings.solPassword, obscureText: true),
          FormTextField(_greClientId, Strings.greClientId),
          FormTextField(
            _greClientSecret,
            Strings.greClientSecret,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
