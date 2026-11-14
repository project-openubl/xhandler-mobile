import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../data/secure_store.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../company/company_repository.dart';

/// Which service fills customer data from their RUC/DNI, and its access
class LookupSettingsPage extends ConsumerStatefulWidget {
  const LookupSettingsPage(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<LookupSettingsPage> createState() => _LookupSettingsPageState();
}

class _LookupSettingsPageState extends ConsumerState<LookupSettingsPage> {
  final _form = GlobalKey<FormState>();
  late LookupProvider _provider = widget.company.lookupProvider;
  late final _url = TextEditingController(text: widget.company.lookupUrl);
  final _token = TextEditingController();
  final _user = TextEditingController();
  final _password = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final controller in [_url, _token, _user, _password]) {
      controller.dispose();
    }
    super.dispose();
  }

  /// searchpe's token is "user:password" (basic authentication)
  Future<void> _load() async {
    final secrets = await ref
        .read(companyRepositoryProvider)
        .readSecrets(widget.company.id);
    if (!mounted) return;
    final token = secrets.lookupToken ?? '';
    setState(() {
      if (_provider == LookupProvider.searchpe) {
        final (user, password) = switch (token.indexOf(':')) {
          -1 => (token, ''),
          final colon => (
            token.substring(0, colon),
            token.substring(colon + 1),
          ),
        };
        _user.text = user;
        _password.text = password;
      } else {
        _token.text = token;
      }
      _loaded = true;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final repository = ref.read(companyRepositoryProvider);
    final token = switch (_provider) {
      LookupProvider.none => null,
      LookupProvider.decolecta => optionalText(_token),
      LookupProvider.searchpe =>
        _user.text.trim().isEmpty && _password.text.isEmpty
            ? null
            : '${_user.text.trim()}:${_password.text}',
    };
    await repository.update(
      widget.company.id,
      CompaniesCompanion(
        lookupProvider: Value(_provider),
        lookupUrl: Value(
          _provider == LookupProvider.searchpe ? optionalText(_url) : null,
        ),
      ),
    );
    await repository.writeSecrets(widget.company.id, {
      CompanySecret.lookupToken: token,
    });
    if (!mounted) return;
    showMessage(context, Strings.saved);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.lookupSettings),
        actions: [SaveButton(onPressed: _loaded ? _save : null)],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!_loaded) const LinearProgressIndicator(),
            RadioGroup<LookupProvider>(
              groupValue: _provider,
              onChanged: (provider) => setState(() => _provider = provider!),
              child: const Column(
                children: [
                  RadioListTile(
                    value: LookupProvider.none,
                    title: Text(Strings.lookupNone),
                  ),
                  RadioListTile(
                    value: LookupProvider.decolecta,
                    title: Text(Strings.lookupDecolecta),
                    subtitle: Text(Strings.lookupDecolectaHelp),
                  ),
                  RadioListTile(
                    value: LookupProvider.searchpe,
                    title: Text(Strings.lookupSearchpe),
                    subtitle: Text(Strings.lookupSearchpeHelp),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_provider == LookupProvider.decolecta)
              FormTextField(
                _token,
                Strings.lookupToken,
                obscureText: true,
                validator: (token) => token.isEmpty ? Strings.required : null,
              ),
            if (_provider == LookupProvider.searchpe) ...[
              FormTextField(
                _url,
                Strings.lookupUrl,
                keyboardType: TextInputType.url,
                validator: (url) {
                  final uri = Uri.tryParse(url);
                  final valid =
                      uri != null &&
                      (uri.scheme == 'https' || uri.scheme == 'http') &&
                      uri.host.isNotEmpty;
                  return valid ? null : Strings.invalidUrl;
                },
              ),
              FormTextField(_user, Strings.lookupUser),
              FormTextField(
                _password,
                Strings.lookupPassword,
                obscureText: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
