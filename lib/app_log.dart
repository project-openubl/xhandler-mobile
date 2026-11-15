import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Errors the app couldn't show or handle, kept in a small file the user can
/// share from Diagnostics (there is no crash reporting service). Callers log
/// error types and messages, never secrets.
abstract final class AppLog {
  /// Past this size, only the newest half is kept
  static const maxBytes = 256 * 1024;

  static File? _file;

  /// Where the log is; `null` before [init] (e.g. in tests)
  static File? get file => _file;

  static Future<void> init() async {
    _file = File('${(await getApplicationSupportDirectory()).path}/app.log');
  }

  /// Records [error] that happened while doing [what]
  static void error(String what, Object error, [StackTrace? stack]) {
    final entry =
        '${DateTime.now().toUtc().toIso8601String()} $what: $error\n'
        '${stack == null ? '' : '$stack\n'}';
    debugPrint(entry);
    final file = _file;
    if (file == null) return;
    try {
      file.writeAsStringSync(entry, mode: FileMode.append, flush: true);
      // The app and the background outbox may both trim at once: losing an
      // entry then is acceptable
      if (file.lengthSync() > maxBytes) {
        final text = file.readAsStringSync();
        final cut = text.indexOf('\n', text.length - maxBytes ~/ 2);
        file.writeAsStringSync(cut < 0 ? '' : text.substring(cut + 1));
      }
    } on FileSystemException catch (failure) {
      debugPrint('AppLog: $failure');
    }
  }

  /// Logs errors nothing else caught: in widgets, and in async code
  static void catchUncaught() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      error('Flutter', details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (exception, stack) {
      error('Uncaught', exception, stack);
      return true;
    };
  }

  @visibleForTesting
  static set file(File? file) => _file = file;
}
