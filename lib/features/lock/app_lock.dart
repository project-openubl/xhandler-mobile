import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app_log.dart';
import '../../data/providers.dart';
import '../../strings.dart';
import 'device_auth.dart';

/// Device setting with the minutes the app may stay in the background
/// before it locks again; not set when the lock is off (DESIGN §11)
const appLockKey = 'app_lock_minutes';

final appLockMinutesProvider = StreamProvider<int?>(
  (ref) => ref
      .watch(databaseProvider)
      .watchSetting(appLockKey)
      // A value that isn't a number locks on leaving, rather than not at all
      .map((value) => value == null ? null : int.tryParse(value) ?? 0),
);

/// What covers the app
enum _Cover {
  /// Until the setting is read: nothing shows, nothing to tap
  blank,
  locked,
  none,
}

/// Covers [child] until the user unlocks the phone's lock: when the app
/// starts and after it was in the background for the chosen minutes. The
/// app keeps its state underneath.
class AppLock extends ConsumerStatefulWidget {
  const AppLock({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLock> createState() => _AppLockState();
}

class _AppLockState extends ConsumerState<AppLock> {
  late final AppLifecycleListener _lifecycle;
  var _cover = _Cover.blank;
  DateTime? _hiddenAt;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onHide: _hidden, onShow: _shown);
    ref.listenManual(appLockMinutesProvider, (_, minutes) {
      if (minutes.hasValue) {
        unawaited(PrivacyScreen.set(enabled: minutes.value != null));
      }
    }, fireImmediately: true);
    unawaited(_start());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    int? minutes;
    try {
      minutes = await ref.read(appLockMinutesProvider.future);
    } on Object catch (error, stack) {
      // Failing safe: ask for the phone's lock rather than show the app
      AppLog.error('App lock', error, stack);
      minutes = 0;
    }
    if (!mounted) return;
    if (minutes == null) {
      setState(() => _cover = _Cover.none);
    } else {
      setState(() => _cover = _Cover.locked);
      await _unlock();
    }
  }

  void _hidden() {
    // The system's unlock dialog hides the app too
    if (!ref.read(deviceAuthProvider).busy) _hiddenAt = clock.now();
  }

  void _shown() {
    final hiddenAt = _hiddenAt;
    final minutes = ref.read(appLockMinutesProvider).value;
    _hiddenAt = null;
    if (_cover != _Cover.none || hiddenAt == null || minutes == null) return;
    final away = clock.now().difference(hiddenAt);
    // A clock set back in time doesn't keep it open
    if (away.isNegative || away >= Duration(minutes: minutes)) {
      setState(() => _cover = _Cover.locked);
      unawaited(_unlock());
    }
  }

  Future<void> _unlock() async {
    if (await ref.read(deviceAuthProvider).authenticate() && mounted) {
      setState(() => _cover = _Cover.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    final covered = _cover != _Cover.none;
    return Stack(
      children: [
        // Screen readers and keyboards can't reach what's behind the lock
        ExcludeSemantics(
          excluding: covered,
          child: ExcludeFocus(
            excluding: covered,
            child: TickerMode(enabled: !covered, child: widget.child),
          ),
        ),
        switch (_cover) {
          _Cover.blank => Positioned.fill(
            child: ColoredBox(color: Theme.of(context).colorScheme.surface),
          ),
          _Cover.locked => _LockScreen(onUnlock: _unlock),
          _Cover.none => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.onUnlock});

  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: Material(
        color: theme.colorScheme.surface,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(Strings.locked, style: theme.textTheme.titleLarge),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onUnlock,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text(Strings.unlock),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
