import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/providers.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'app_lock.dart';
import 'device_auth.dart';

/// Turns the app lock on or off and picks after how long it locks again
class SecurityPage extends ConsumerWidget {
  const SecurityPage({super.key});

  /// [RadioGroup] value of "off" (the setting isn't stored)
  static const _off = -1;

  static const _choices = [_off, 0, 1, 5, 15];

  Future<void> _choose(
    BuildContext context,
    WidgetRef ref, {
    required int? current,
    required int minutes,
  }) async {
    final database = ref.read(databaseProvider);
    if (minutes == _off) {
      await database.deleteSetting(appLockKey);
      return;
    }
    // Turning it on proves the phone's lock works before relying on it;
    // changing the time doesn't ask again
    if (current == null) {
      final auth = ref.read(deviceAuthProvider);
      if (!await auth.isAvailable()) {
        if (context.mounted) showMessage(context, Strings.lockNeedsScreenLock);
        return;
      }
      if (!await auth.authenticate()) return;
    }
    await database.setSetting(appLockKey, '$minutes');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minutes = ref.watch(appLockMinutesProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.security)),
      body: ListView(
        children: [
          const ListTile(
            title: Text(Strings.appLock),
            subtitle: Text(Strings.appLockHelp),
          ),
          RadioGroup<int>(
            groupValue: minutes ?? _off,
            onChanged: (choice) =>
                _choose(context, ref, current: minutes, minutes: choice!),
            child: Column(
              children: [
                for (final choice in _choices)
                  RadioListTile(
                    value: choice,
                    title: Text(switch (choice) {
                      _off => Strings.lockOff,
                      0 => Strings.lockImmediately,
                      _ => Strings.lockAfter(choice),
                    }),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
