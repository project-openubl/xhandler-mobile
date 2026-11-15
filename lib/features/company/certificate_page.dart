import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../data/secure_store.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/signer.dart';
import '../../src/rust/api/sunat.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../document/sunat_bridge.dart';
import 'certificate_status.dart';
import 'company_repository.dart';

/// Imports the company's certificate (.pfx): checks its password and
/// validity, shows who it belongs to, and keeps it in secure storage
class CertificatePage extends ConsumerStatefulWidget {
  const CertificatePage(this.company, {super.key});

  final Company company;

  @override
  ConsumerState<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends ConsumerState<CertificatePage> {
  final _password = TextEditingController();

  Uint8List? _selected;
  String? _selectedName;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _select() async {
    // Any type: certificates shared by chat or e-mail often lose theirs
    final files = await FilePicker.pickFiles();
    if (files.isEmpty) return;
    final bytes = await files.first.readAsBytes();
    if (!mounted) return;
    setState(() {
      _selected = bytes;
      _selectedName = files.first.name;
      _error = null;
    });
  }

  Future<void> _save() async {
    final certificate = _selected!;
    final password = _password.text;
    final repository = ref.read(companyRepositoryProvider);
    final CertificateInfo info;
    try {
      info = await ref.read(sunatBridgeProvider).inspect(certificate, password);
    } on BridgeError catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.kind == BridgeErrorKind.wrongPassword
            ? Strings.certificateWrongPassword
            : Strings.certificateInvalid;
      });
      return;
    }
    final now = DateTime.now();
    final invalid = info.validUntil.isBefore(now)
        ? Strings.certificateExpired
        : info.validFrom.isAfter(now)
        ? Strings.certificateNotYetValid
        : null;
    if (invalid != null) {
      if (mounted) setState(() => _error = invalid);
      return;
    }
    if (!mounted) return;
    if (info.ruc != widget.company.ruc &&
        !await confirm(
          context,
          message: Strings.certificateOtherRuc(info.ruc),
          accept: Strings.save,
        )) {
      return;
    }

    await repository.writeSecrets(widget.company.id, {
      CompanySecret.certificate: base64Encode(certificate),
      CompanySecret.certificatePassword: password,
    });
    ref.invalidate(savedCertificateProvider(widget.company.id));
    if (!mounted) return;
    showMessage(context, Strings.saved);
    setState(() {
      _selected = null;
      _selectedName = null;
      _error = null;
      _password.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saved = ref.watch(savedCertificateProvider(widget.company.id));
    final testMode = widget.company.sunatEnvironment == SunatEnvironment.beta;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.certificate)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          switch (saved) {
            AsyncData(value: final info?) => _CertificateSummary(info),
            AsyncData() || AsyncError() => ListTile(
              leading: const Icon(Icons.gpp_maybe),
              title: Text(
                saved.hasError
                    ? Strings.certificateUnreadable
                    : Strings.certificateMissing,
              ),
              subtitle: testMode
                  ? const Text(Strings.certificateTestModeHelp)
                  : null,
            ),
            _ => const LinearProgressIndicator(),
          },
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _select,
            icon: const Icon(Icons.upload_file),
            label: Text(_selectedName ?? Strings.certificateSelect),
          ),
          if (_selected != null) ...[
            const SizedBox(height: 12),
            FormTextField(
              _password,
              Strings.certificatePassword,
              obscureText: true,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            SaveButton(onPressed: _save, filled: true),
          ],
        ],
      ),
    );
  }
}

class _CertificateSummary extends StatelessWidget {
  const _CertificateSummary(this.info);

  final CertificateInfo info;

  @override
  Widget build(BuildContext context) {
    final validUntil = info.validUntil.toLocal();
    final warning = certificateWarning(validUntil);
    final date = MaterialLocalizations.of(context).formatMediumDate(validUntil);
    // e.g. "CN=EMPRESA S.A.C.,O=..." → "EMPRESA S.A.C."
    final holder =
        RegExp(r'CN=([^,]+)').firstMatch(info.subject)?.group(1) ??
        info.subject;
    return ListTile(
      leading: Icon(
        warning == null ? Icons.verified_user : Icons.warning,
        color: warning == null ? null : Theme.of(context).colorScheme.error,
      ),
      title: Text(holder),
      subtitle: Text(
        [
          if (info.ruc != null) '${Strings.ruc} ${info.ruc}',
          Strings.certificateValidUntil(date),
          ?warning,
        ].join('\n'),
      ),
      isThreeLine: true,
    );
  }
}
