import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

import '../../app_restart.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../peru_date.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../pdf/share_document.dart';
import 'backup_service.dart';

final backupServiceProvider = Provider(
  (ref) => BackupService(ref.watch(secureStoreProvider), getTemporaryDirectory),
);

/// When this device last made a backup
const _lastBackupKey = 'last_backup_at';

final _lastBackupProvider = StreamProvider.autoDispose<DateTime?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.deviceSettings)
        ..where((s) => s.key.equals(_lastBackupKey)))
      .watchSingleOrNull()
      .map((row) => row == null ? null : DateTime.parse(row.value));
});

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

  Future<void> _create(BuildContext anchor) async {
    if (!_form.currentState!.validate()) return;
    final db = ref.read(databaseProvider);
    try {
      final backup = await ref
          .read(backupServiceProvider)
          .create(db, _password.text);
      if (!anchor.mounted) return;
      final saved = await shareFiles(
        [
          (
            name: 'xhandler-${peruToday()}.xhbackup',
            mimeType: 'application/octet-stream',
            bytes: backup,
          ),
        ],
        subject: Strings.backupTitle,
        anchor: anchor,
      );
      if (!saved) return;
      await db
          .into(db.deviceSettings)
          .insertOnConflictUpdate(
            DeviceSettingsCompanion(
              key: const Value(_lastBackupKey),
              value: Value(DateTime.now().toUtc().toIso8601String()),
            ),
          );
      _password.clear();
      _confirmation.clear();
      if (anchor.mounted) showMessage(anchor, Strings.backupCreated);
    } on Object catch (error) {
      debugPrint('Backup: $error');
      if (anchor.mounted) showMessage(anchor, Strings.unexpectedError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = ref.watch(_lastBackupProvider).value;
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
            const Divider(height: 48),
            OutlinedButton.icon(
              onPressed: () => restoreBackup(context, ref),
              icon: const Icon(Icons.restore),
              label: const Text(Strings.restoreBackup),
            ),
          ],
        ),
      ),
    );
  }
}

/// Replaces everything on this phone with a backup file the user picks,
/// then starts the app over
Future<void> restoreBackup(BuildContext context, WidgetRef ref) async {
  final picked = await FilePicker.pickFiles();
  if (picked.isEmpty) return;
  final bytes = await picked.first.readAsBytes();
  if (!context.mounted) return;
  final password = await showDialog<String>(
    context: context,
    builder: (_) => const _RestoreDialog(),
  );
  if (password == null || !context.mounted) return;
  final db = ref.read(databaseProvider);
  final service = ref.read(backupServiceProvider);
  try {
    showMessage(context, Strings.restoring);
    final backup = await service.open(
      bytes,
      password: password,
      schemaVersion: db.schemaVersion,
    );
    await db.close();
    await service.install(backup, await databaseFile());
    await restartApp();
  } on WrongPasswordError {
    if (context.mounted) showMessage(context, Strings.wrongBackupPassword);
  } on InvalidBackupError catch (error) {
    if (context.mounted) {
      showMessage(
        context,
        error.newerVersion ? Strings.backupNeedsUpdate : Strings.notABackup,
      );
    }
  } on Object catch (error) {
    debugPrint('Restore: $error');
    if (context.mounted) showMessage(context, Strings.unexpectedError);
  }
}

/// The backup's password, after warning that everything is replaced
class _RestoreDialog extends StatefulWidget {
  const _RestoreDialog();

  @override
  State<_RestoreDialog> createState() => _RestoreDialogState();
}

class _RestoreDialogState extends State<_RestoreDialog> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.restoreBackup),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(Strings.restoreWarning),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
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
          onPressed: () => Navigator.pop(context, _password.text),
          child: const Text(Strings.restore),
        ),
      ],
    );
  }
}
