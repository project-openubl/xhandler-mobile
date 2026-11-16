import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workmanager/workmanager.dart';

import '../../app_log.dart';
import '../../app_restart.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../peru_date.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../company/company_repository.dart';
import '../document/background_outbox.dart';
import 'backup_service.dart';

/// Backups of everything in a file protected by a password, to keep in a
/// safe place and restore on a new phone (docs/DESIGN.md §9)
class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  /// A backup of everything, or of [company] alone to move it to another
  /// phone
  Future<void> _create(BuildContext anchor, {Company? company}) async {
    if (!_form.currentState!.validate()) return;
    final db = ref.read(databaseProvider);
    File? backup;
    try {
      backup = await ref
          .read(backupServiceProvider)
          .create(db, _password.text, onlyCompanyId: company?.id);
      if (!anchor.mounted) return;
      final box = anchor.findRenderObject() as RenderBox?;
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(backup.path, mimeType: 'application/octet-stream')],
          fileNameOverrides: [
            'xhandler-${company == null ? '' : '${company.ruc}-'}'
                '${peruToday()}.xhbackup',
          ],
          subject: Strings.backupTitle,
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
      if (result.status == ShareResultStatus.dismissed) return;
      // Only a backup of everything is one
      if (company == null) {
        await db.setSetting(lastBackupKey, nowUtc().toIso8601String());
      }
      _password.clear();
      _confirmation.clear();
      if (anchor.mounted) showMessage(anchor, Strings.backupCreated);
    } on Object catch (error, stack) {
      AppLog.error('Backup', error, stack);
      if (anchor.mounted) showMessage(anchor, Strings.unexpectedError);
    } finally {
      if (backup != null && backup.existsSync()) await backup.delete();
    }
  }

  /// Adds the companies of a backup file this phone doesn't have
  Future<void> _import(BuildContext context) => _withPickedBackup(
    context,
    ref,
    dialog: const _PasswordDialog(
      title: Strings.importCompanies,
      help: Strings.importHelp,
      accept: Strings.import,
    ),
    progress: Strings.importing,
    logTag: 'Import',
    // The outbox's own connection may wait for the copy and skip a round
    use: (backup) async {
      final added = await ref
          .read(backupServiceProvider)
          .merge(backup, ref.read(databaseProvider));
      return added.isEmpty
          ? Strings.nothingToImport
          : Strings.imported(added.join(', '));
    },
  );

  @override
  Widget build(BuildContext context) {
    final last = ref.watch(lastBackupProvider).value;
    final company = ref.watch(activeCompanyProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.backupTitle)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(Strings.backupHelp),
            const SizedBox(height: 8),
            Text(
              last == null
                  ? Strings.noBackupYet
                  : Strings.lastBackup(
                      MaterialLocalizations.of(context)
                          .formatMediumDate(last.toLocal()),
                    ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FormTextField(
              _password,
              Strings.backupPassword,
              obscureText: true,
              helperText: Strings.backupPasswordHelp,
              validator: (text) =>
                  text.length < 8 ? Strings.backupPasswordTooShort : null,
            ),
            FormTextField(
              _confirmation,
              Strings.backupPasswordConfirmation,
              obscureText: true,
              validator: (text) =>
                  text == _password.text ? null : Strings.passwordsDiffer,
            ),
            Builder(
              builder: (anchor) => SaveButton(
                label: Strings.createBackup,
                filled: true,
                onPressed: () => _create(anchor),
              ),
            ),
            if (company != null) ...[
              const SizedBox(height: 8),
              Builder(
                builder: (anchor) => SaveButton(
                  label: Strings.exportCompany(
                    company.nombreComercial ?? company.razonSocial,
                  ),
                  onPressed: () => _create(anchor, company: company),
                ),
              ),
            ],
            const Divider(height: 48),
            OutlinedButton.icon(
              onPressed: () => restoreBackup(context, ref),
              icon: const Icon(Icons.restore),
              label: const Text(Strings.restoreBackup),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _import(context),
              icon: const Icon(Icons.download),
              label: const Text(Strings.importCompanies),
            ),
          ],
        ),
      ),
    );
  }
}

/// Replaces everything on this phone with a backup file the user picks,
/// after its password. The app starts over with the restored data.
Future<void> restoreBackup(BuildContext context, WidgetRef ref) =>
    _withPickedBackup(
      context,
      ref,
      dialog: const _PasswordDialog(
        title: Strings.restoreBackup,
        help: Strings.restoreWarning,
        accept: Strings.restore,
      ),
      progress: Strings.restoring,
      logTag: 'Restore',
      use: (backup) async {
        final db = ref.read(databaseProvider);
        // The background outbox has its own connection to the database
        await Workmanager().cancelByUniqueName(outboxTask);
        await db.close();
        try {
          await ref
              .read(backupServiceProvider)
              .install(backup, await databaseFile());
        } finally {
          // The restored database, or the old one if installing failed
          await restartApp();
        }
        return null;
      },
    );

/// Picks a backup file, opens it with the password [dialog] asks for and
/// hands it to [use] behind a progress dialog. [use] returns a message to
/// show once done, or `null` when the app starts over.
Future<void> _withPickedBackup(
  BuildContext context,
  WidgetRef ref, {
  required _PasswordDialog dialog,
  required String progress,
  required String logTag,
  required Future<String?> Function(OpenedBackup backup) use,
}) async {
  final password = await showDialog<String>(
    context: context,
    builder: (_) => dialog,
  );
  if (password == null || !context.mounted) return;
  final service = ref.read(backupServiceProvider);
  final schemaVersion = ref.read(databaseProvider).schemaVersion;
  final navigator = Navigator.of(context, rootNavigator: true);
  File? picked;
  var showingProgress = false;
  try {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty || !context.mounted) return;
    showingProgress = true;
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 24),
                Expanded(child: Text(progress)),
              ],
            ),
          ),
        ),
      ),
    );
    // Copied in pieces: backups can be large
    picked = File(
      '${(await getTemporaryDirectory()).path}/picked-${DateTime.now().microsecondsSinceEpoch}',
    );
    final sink = picked.openWrite();
    await sink.addStream(files.first.readAsByteStream());
    await sink.close();
    final backup = await service.open(
      picked,
      password: password,
      schemaVersion: schemaVersion,
    );
    final done = await use(backup);
    if (done == null) return; // the app starts over
    showingProgress = false;
    navigator.pop();
    if (context.mounted) showMessage(context, done);
  } on Object catch (error, stack) {
    if (showingProgress) navigator.pop();
    final message = switch (error) {
      WrongPasswordError() => Strings.wrongBackupPassword,
      InvalidBackupError(newerVersion: true) => Strings.backupNeedsUpdate,
      InvalidBackupError() => Strings.notABackup,
      _ => Strings.unexpectedError,
    };
    if (message == Strings.unexpectedError) {
      AppLog.error(logTag, error, stack);
    }
    if (context.mounted) showMessage(context, message);
  } finally {
    if (picked != null && picked.existsSync()) await picked.delete();
  }
}

/// A backup's password, after saying what will happen with it
class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog({
    required this.title,
    required this.help,
    required this.accept,
  });

  final String title;
  final String help;
  final String accept;

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.help),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: Strings.backupPassword,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: _password.text.isEmpty
              ? null
              : () => Navigator.pop(context, _password.text),
          child: Text(widget.accept),
        ),
      ],
    );
  }
}
