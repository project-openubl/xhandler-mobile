import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../data/secure_store.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/page_list_view.dart';
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
  final _token = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final secrets = await ref
        .read(companyRepositoryProvider)
        .readSecrets(widget.company.id);
    if (!mounted) return;
    setState(() {
      _token.text = secrets.lookupToken ?? '';
      _loaded = true;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final repository = ref.read(companyRepositoryProvider);
    final token = switch (_provider) {
      LookupProvider.none => null,
      LookupProvider.decolecta => optionalText(_token),
    };
    await repository.update(
      widget.company.id,
      CompaniesCompanion(lookupProvider: Value(_provider)),
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
        child: PageListView(
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
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_provider == LookupProvider.decolecta) ...[
              const RequiredFieldsLegend(),
              FormTextField(
                _token,
                Strings.lookupToken,
                required: true,
                obscureText: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
