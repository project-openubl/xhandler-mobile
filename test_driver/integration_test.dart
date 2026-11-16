import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Runs the integration tests; screenshots they take go to
/// build/e2e_screenshots/
Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    final file = File('build/e2e_screenshots/$name.png');
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);
    return true;
  },
);
