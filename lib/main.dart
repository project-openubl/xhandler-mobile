import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/database.dart';
import 'data/providers.dart';
import 'data/secure_store.dart';
import 'src/rust/frb_generated.dart';
import 'strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await _start();
}

Future<void> _start() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/xhandler.db');
  void showDatabaseError() => runApp(
    _DatabaseErrorApp(
      onStartOver: () async {
        await file.delete();
        await _start();
      },
    ),
  );

  final String key;
  try {
    key = await SecureStore().databaseKey(databaseExists: file.existsSync());
  } on DatabaseKeyLostError {
    return showDatabaseError();
  }
  final database = AppDatabase(openEncryptedDatabase(file, key));
  try {
    // Fails if the key doesn't open the file
    await database.customSelect('SELECT count(*) FROM sqlite_master').get();
  } on Exception {
    await database.close();
    return showDatabaseError();
  }
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const App(),
    ),
  );
}

/// Shown when the database can't be opened, e.g. its key was lost
class _DatabaseErrorApp extends StatelessWidget {
  const _DatabaseErrorApp({required this.onStartOver});

  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Strings.databaseErrorTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                const Text(Strings.databaseErrorText),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: onStartOver,
                  child: const Text(Strings.startOver),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
