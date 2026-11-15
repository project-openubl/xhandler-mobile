import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/app_log.dart';

void main() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('xhandler');
    AppLog.file = File('${directory.path}/app.log');
  });
  tearDown(() async {
    AppLog.file = null;
    await directory.delete(recursive: true);
  });

  test('appends errors with what was being done', () {
    AppLog.error('Outbox', const FormatException('bad answer'));
    AppLog.error('Backup', StateError('no space'));

    final text = AppLog.file!.readAsStringSync();
    expect(text, contains('Outbox: FormatException: bad answer'));
    expect(text, contains('Backup: Bad state: no space'));
  });

  test('keeps the newest half when the file grows too big', () {
    final line = 'x' * 1000;
    for (var i = 0; i < 300; i++) {
      AppLog.error('Step $i', line);
    }

    final text = AppLog.file!.readAsStringSync();
    expect(text.length, lessThanOrEqualTo(AppLog.maxBytes));
    expect(text, contains('Step 299'));
    expect(text, isNot(contains('Step 0:')));
  });
}
