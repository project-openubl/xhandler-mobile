import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;

import 'app.dart';
import 'data/database.dart';
import 'data/providers.dart';
import 'data/secure_store.dart';
import 'src/rust/frb_generated.dart';
import 'strings.dart';
import 'widgets/form_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await _start();
}

Future<void> _start() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/xhandler.db');
  try {
    final key = await SecureStore().databaseKey(
      databaseExists: file.existsSync(),
    );
    checkKeyOpens(file, key);
    runApp(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(
            AppDatabase(openEncryptedDatabase(file, key)),
          ),
        ],
        child: const App(),
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
