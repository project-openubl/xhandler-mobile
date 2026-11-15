import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../data/secure_store.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../company/company_repository.dart';
import 'delivery_service.dart';
import 'email_sender.dart';

/// Servers of the common providers: host and port
const _presets = {
  'Gmail': ('smtp.gmail.com', '465'),
  // Outlook and Microsoft 365 dropped app passwords for SMTP: they wait
  // for Microsoft Graph (docs/DESIGN.md §14)
};

/// The company's email account, to send documents to customers
/// (docs/DESIGN.md §8). Kept in secure storage.
class EmailSettingsPage extends ConsumerStatefulWidget {
  const EmailSettingsPage(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<EmailSettingsPage> createState() => _EmailSettingsPageState();
}

class _EmailSettingsPageState extends ConsumerState<EmailSettingsPage> {
  final _form = GlobalKey<FormState>();
  final _host = TextEditingController();
  final _port = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  /// Saving before the current values are loaded would delete them
  bool _loaded = false;

  /// A test email is on its way
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    for (final controller in [_host, _port, _username, _password]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final secrets = await ref
        .read(companyRepositoryProvider)
        .readSecrets(widget.company.id);
    if (!mounted) return;
    setState(() {
      _host.text = secrets.smtpHost ?? '';
      _port.text = '${secrets.smtpPort ?? ''}';
      _username.text = secrets.smtpUsername ?? widget.company.email ?? '';
      _password.text = secrets.smtpPassword ?? '';
      _loaded = true;
    });
  }

  SmtpSettings get _settings => (
    host: _host.text.trim(),
    port: int.parse(_port.text.trim()),
    username: _username.text.trim(),
    password: _password.text.trim(),
  );

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final settings = _settings;
    await ref.read(companyRepositoryProvider).writeSecrets(widget.company.id, {
      CompanySecret.smtpHost: settings.host,
      CompanySecret.smtpPort: '${settings.port}',
      CompanySecret.smtpUsername: settings.username,
      CompanySecret.smtpPassword: settings.password,
    });
    if (!mounted) return;
    showMessage(context, Strings.saved);
    Navigator.of(context).maybePop();
  }

  Future<void> _test() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _testing = true);
    showMessage(context, Strings.sending);
    try {
      await ref
          .read(deliveryServiceProvider)
          .testEmail(widget.company, _settings);
      if (mounted) {
        showMessage(context, Strings.testEmailSent(_settings.username));
      }
    } on EmailException catch (error) {
      if (mounted) showMessage(context, emailErrorMessage(error.error));
    } on Object catch (error) {
      debugPrint('Test email: $error');
      if (mounted) showMessage(context, Strings.unexpectedError);
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? required(String text) => text.isEmpty ? Strings.required : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.emailSettings),
        actions: [SaveButton(onPressed: _loaded ? _save : null)],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!_loaded) const LinearProgressIndicator(),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(Strings.emailSettingsHelp),
            ),
            Wrap(
              spacing: 8,
              children: [
                for (final MapEntry(key: name, value: (host, port))
                    in _presets.entries)
                  ActionChip(
                    label: Text(name),
                    onPressed: _loaded
                        ? () => setState(() {
                            _host.text = host;
                            _port.text = port;
                          })
                        : null,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            FormTextField(
              _host,
              Strings.smtpHost,
              enabled: _loaded,
              validator: required,
            ),
            FormTextField(
              _port,
              Strings.smtpPort,
              enabled: _loaded,
              digitsOnly: true,
              maxLength: 5,
              validator: (text) =>
                  int.tryParse(text) == null ? Strings.required : null,
            ),
            FormTextField(
              _username,
              Strings.email,
              enabled: _loaded,
              keyboardType: TextInputType.emailAddress,
              validator: (text) => isEmail(text) ? null : Strings.invalidEmail,
            ),
            FormTextField(
              _password,
              Strings.appPassword,
              enabled: _loaded,
              obscureText: true,
              helperText: Strings.appPasswordHelp,
              validator: required,
            ),
            const SizedBox(height: 8),
            SaveButton(
              label: Strings.sendTestEmail,
              onPressed: _loaded && !_testing ? _test : null,
            ),
          ],
        ),
      ),
    );
  }
}

String emailErrorMessage(EmailError error) => switch (error) {
  EmailError.authentication => Strings.emailAuthenticationError,
  EmailError.connection => Strings.emailConnectionError,
  EmailError.rejected => Strings.emailRejectedError,
};
