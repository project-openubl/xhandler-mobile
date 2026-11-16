import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;

import 'app.dart';
import 'app_log.dart';
import 'app_restart.dart';
import 'data/database.dart';
import 'data/providers.dart';
import 'data/secure_store.dart';
import 'features/appearance/theme_mode.dart';
import 'features/document/outbox_runner.dart';
import 'src/rust/frb_generated.dart';
import 'strings.dart';
import 'widgets/form_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLog.init();
  AppLog.catchUncaught();
  await RustLib.init();
  restartApp = _start;
  await _start();
}

Future<void> _start() async {
  final file = await databaseFile();
  try {
    final key = await SecureStore().databaseKey(
      databaseExists: file.existsSync(),
    );
    checkKeyOpens(file, key);
    final database = AppDatabase(openEncryptedDatabase(file, key));
    final themeMode = await _storedThemeMode(database);
    runApp(
      ProviderScope(
        // A new scope on every start (e.g. after a restore): providers,
        // the router and the outbox start over with the database
        key: UniqueKey(),
        overrides: [databaseProvider.overrideWithValue(database)],
        child: OutboxRunner(child: App(initialThemeMode: themeMode)),
      ),
    );
  } on Object catch (error) {
    final keyLost =
        error is DatabaseKeyLostError ||
        (error is SqliteException &&
            error.extendedResultCode == sqliteNotADatabase);
    runApp(
      _StartupErrorApp(
        keyLost: keyLost,
        onRetry: _start,
        onStartOver: () async {
          for (final suffix in ['', '-wal', '-shm', '-journal']) {
            final path = File('${file.path}$suffix');
            if (path.existsSync()) await path.delete();
          }
          await _start();
        },
      ),
    );
  }
}

/// The theme mode, read before the first frame so the app doesn't flash the
/// phone's mode. Failing here mustn't stop the app: it follows the phone.
Future<ThemeMode> _storedThemeMode(AppDatabase database) async {
  try {
    return themeModeFrom(await database.setting(themeModeKey));
  } on Object catch (error, stack) {
    AppLog.error('Theme mode', error, stack);
    return ThemeMode.system;
  }
}

/// Shown when the app can't start. Only a lost key offers to start over
/// (deleting the data); any other problem can just be retried.
class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({
    required this.keyLost,
    required this.onRetry,
    required this.onStartOver,
  });

  final bool keyLost;
  final Future<void> Function() onRetry;
  final Future<void> Function() onStartOver;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    keyLost
                        ? Strings.databaseErrorTitle
                        : Strings.startupErrorTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    keyLost
                        ? Strings.databaseErrorText
                        : Strings.unexpectedError,
                  ),
                  const SizedBox(height: 32),
                  if (keyLost)
                    SaveButton(
                      label: Strings.startOver,
                      filled: true,
                      onPressed: () async {
                        if (await confirm(
                          context,
                          message: Strings.startOverConfirm,
                          accept: Strings.startOver,
                        )) {
                          await onStartOver();
                        }
                      },
                    )
                  else
                    SaveButton(
                      label: Strings.retry,
                      filled: true,
                      onPressed: onRetry,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
