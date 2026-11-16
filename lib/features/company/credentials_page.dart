import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../data/secure_store.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'certificate_status.dart';
import 'company_repository.dart';

/// SOL user and the API client for guías de remisión, kept in secure storage
class CredentialsPage extends ConsumerStatefulWidget {
  const CredentialsPage(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends ConsumerState<CredentialsPage> {
  /// SOL users are the RUC followed by the user's name; only the name is typed
  final _solUser = TextEditingController();
  final _solPassword = TextEditingController();
  final _greClientId = TextEditingController();
  final _greClientSecret = TextEditingController();

  /// Saving before the current values are loaded would delete them
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    for (final controller in [
      _solUser,
      _solPassword,
      _greClientId,
      _greClientSecret,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final secrets = await ref
        .read(companyRepositoryProvider)
        .readSecrets(widget.company.id);
    if (!mounted) return;
    final username = secrets.solUsername ?? '';
    setState(() {
      _solUser.text = username.startsWith(widget.company.ruc)
          ? username.substring(widget.company.ruc.length)
          : username;
      _solPassword.text = secrets.solPassword ?? '';
      _greClientId.text = secrets.greClientId ?? '';
      _greClientSecret.text = secrets.greClientSecret ?? '';
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final user = optionalText(_solUser);
    await ref.read(companyRepositoryProvider).writeSecrets(widget.company.id, {
      CompanySecret.solUsername: user == null
          ? null
          : '${widget.company.ruc}${user.toUpperCase()}',
      CompanySecret.solPassword: optionalText(_solPassword),
      CompanySecret.greClientId: optionalText(_greClientId),
      CompanySecret.greClientSecret: optionalText(_greClientSecret),
    });
    ref.invalidate(hasSolCredentialsProvider(widget.company.id));
    if (!mounted) return;
    showMessage(context, Strings.saved);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.credentials),
        actions: [SaveButton(onPressed: _loaded ? _save : null)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!_loaded) const LinearProgressIndicator(),
          if (widget.company.sunatEnvironment == SunatEnvironment.beta)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(Strings.credentialsTestModeHelp),
            ),
          FormTextField(
            _solUser,
            Strings.solUsername,
            enabled: _loaded,
            prefixText: widget.company.ruc,
            helperText: Strings.solUsernameHelp,
          ),
          FormTextField(
            _solPassword,
            Strings.solPassword,
            enabled: _loaded,
            obscureText: true,
          ),
          FormTextField(_greClientId, Strings.greClientId, enabled: _loaded),
          FormTextField(
            _greClientSecret,
            Strings.greClientSecret,
            enabled: _loaded,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
