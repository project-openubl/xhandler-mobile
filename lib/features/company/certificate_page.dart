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
import 'company_repository.dart';

/// Imports the company's certificate (.pfx): checks its password, shows who
/// it belongs to and until when it is valid, and keeps it in secure storage
class CertificatePage extends ConsumerStatefulWidget {
  const CertificatePage({super.key});

  @override
  ConsumerState<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends ConsumerState<CertificatePage> {
  final _password = TextEditingController();
  late final Company _company = ref.read(activeCompanyProvider).value!;
  CertificateInfo? _info;
  Uint8List? _selected;
  String? _selectedName;
  String? _error;

  @override
  void initState() {
    super.initState();
    _showSaved();
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _showSaved() async {
    final secrets = await ref
        .read(companyRepositoryProvider)
        .readSecrets(_company.id);
    final certificate = secrets.certificate;
    if (certificate == null) return;
    final info = await inspectCertificate(
      certificate: certificate,
      password: secrets.certificatePassword ?? '',
    );
    if (mounted) setState(() => _info = info);
  }

  Future<void> _select() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pfx', 'p12'],
    );
    if (files.isEmpty) return;
    final bytes = await files.first.readAsBytes();
    setState(() {
      _selected = bytes;
      _selectedName = files.first.name;
      _error = null;
    });
  }

  Future<void> _save() async {
    final certificate = _selected;
    if (certificate == null) return;
    final CertificateInfo info;
    try {
      info = await inspectCertificate(
        certificate: certificate,
        password: _password.text,
      );
    } on BridgeError catch (error) {
      setState(() {
        _error = error.kind == BridgeErrorKind.wrongPassword
            ? Strings.certificateWrongPassword
            : Strings.certificateInvalid;
      });
      return;
    }
    if (info.ruc != _company.ruc && !await _confirmOtherRuc(info.ruc)) return;

    await ref.read(companyRepositoryProvider).writeSecrets(_company.id, {
      CompanySecret.certificate: base64Encode(certificate),
      CompanySecret.certificatePassword: _password.text,
    });
    if (!mounted) return;
    setState(() {
      _info = info;
      _selected = null;
      _selectedName = null;
      _error = null;
      _password.clear();
    });
  }

  Future<bool> _confirmOtherRuc(String? ruc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(Strings.certificateOtherRuc(ruc)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(Strings.save),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final info = _info;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.certificate)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (info == null)
            const ListTile(title: Text(Strings.certificateMissing))
          else
            _CertificateSummary(info),
          if (info == null &&
              _company.sunatEnvironment == SunatEnvironment.beta)
            const Text(Strings.certificateTestModeHelp),
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
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _save, child: const Text(Strings.save)),
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
    final daysLeft = validUntil.difference(DateTime.now()).inDays;
    final warning = daysLeft < 0
        ? Strings.certificateExpired
        : daysLeft < 30
        ? Strings.certificateExpiresSoon
        : null;
    final date = MaterialLocalizations.of(context).formatMediumDate(validUntil);
    return ListTile(
      leading: const Icon(Icons.verified_user),
      title: Text(info.ruc ?? info.subject),
      subtitle: Text(
        [
          info.subject,
          Strings.certificateValidUntil(date),
          ?warning,
        ].join('\n'),
      ),
      isThreeLine: true,
    );
  }
}
