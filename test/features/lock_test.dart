import 'package:clock/clock.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/providers.dart';
import 'package:xhandler_mobile/features/lock/app_lock.dart';
import 'package:xhandler_mobile/features/lock/device_auth.dart';
import 'package:xhandler_mobile/features/lock/security_page.dart';
import 'package:xhandler_mobile/strings.dart';

import '../helpers.dart';

/// The phone's lock, answering [unlocks]
class _FakeDeviceAuth implements DeviceAuth {
  bool unlocks = true;
  bool available = true;
  var asked = 0;

  /// Runs while the dialog is open, e.g. the dialog hiding the app
  Future<void> Function()? whileAsking;

  @override
  bool busy = false;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate() async {
    asked++;
    busy = true;
    await whileAsking?.call();
    busy = false;
    return unlocks;
  }
}

/// A platform whose unlock dialog fails, then works
class _FlakyPlatform extends LocalAuthPlatform {
  var calls = 0;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required Iterable<AuthMessages> authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    if (++calls == 1) throw PlatformException(code: 'no_activity');
    return true;
  }
}

void main() {
  late _FakeDeviceAuth auth;

  setUp(() => auth = _FakeDeviceAuth());

  /// The app's content behind the lock
  const content = 'Comprobantes';

  Future<void> pumpApp(WidgetTester tester, TestData data) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(data.database),
          deviceAuthProvider.overrideWithValue(auth),
        ],
        child: MaterialApp(
          builder: (_, child) => AppLock(child: child!),
          home: const Scaffold(body: Text(content)),
        ),
      ),
    );
  }

  Future<void> background(WidgetTester tester) async {
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();
  }

  Future<void> foreground(WidgetTester tester) async {
    for (final state in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();
  }

  bool locked() => find.text(Strings.locked).evaluate().isNotEmpty;

  group('AppLock', () {
    testWidgets('stays out of the way when off', (tester) async {
      final data = TestData();
      await pumpApp(tester, data);
      await data.waitFor(tester, find.text(content));
      await tester.pump();

      expect(locked(), isFalse);
      expect(auth.asked, 0);
      await data.unmount(tester);
    });

    testWidgets('asks for the phone lock on start', (tester) async {
      final data = TestData();
      await tester.runAsync(() => data.database.setSetting(appLockKey, '5'));
      auth.unlocks = false;
      await pumpApp(tester, data);
      await data.waitFor(tester, find.text(Strings.unlock));
      expect(auth.asked, 1);

      auth.unlocks = true;
      await tester.tap(find.text(Strings.unlock));
      await tester.pump();
      expect(auth.asked, 2);
      expect(locked(), isFalse);
      await data.unmount(tester);
    });

    testWidgets('locks again after the chosen time in the background', (
      tester,
    ) async {
      final data = TestData();
      await tester.runAsync(() => data.database.setSetting(appLockKey, '0'));
      await pumpApp(tester, data);
      await data.waitFor(tester, find.text(content));
      await tester.pump();
      expect(locked(), isFalse);

      auth.unlocks = false;
      await background(tester);
      await foreground(tester);
      expect(locked(), isTrue);
      expect(auth.asked, 2);
      await data.unmount(tester);
    });

    testWidgets("the unlock dialog hiding the app isn't leaving it", (
      tester,
    ) async {
      final data = TestData();
      await tester.runAsync(() => data.database.setSetting(appLockKey, '0'));
      // Like Android's PIN screen, an activity over the app
      auth.whileAsking = () async {
        await background(tester);
        await foreground(tester);
      };
      await pumpApp(tester, data);
      await data.waitFor(tester, find.text(content));
      await tester.pump();

      expect(locked(), isFalse);
      expect(auth.asked, 1);
      await data.unmount(tester);
    });

    testWidgets('setting the clock back locks it', (tester) async {
      final data = TestData();
      await tester.runAsync(() => data.database.setSetting(appLockKey, '15'));
      await pumpApp(tester, data);
      await data.waitFor(tester, find.text(content));
      await tester.pump();

      auth.unlocks = false;
      final now = DateTime.now();
      await withClock(Clock.fixed(now), () => background(tester));
      await withClock(
        Clock.fixed(now.subtract(const Duration(hours: 1))),
        () => foreground(tester),
      );
      expect(locked(), isTrue);
      await data.unmount(tester);
    });

    testWidgets('a short trip to the background keeps it open', (tester) async {
      final data = TestData();
      await tester.runAsync(() => data.database.setSetting(appLockKey, '5'));
      await pumpApp(tester, data);
      await data.waitFor(tester, find.text(content));
      await tester.pump();

      await background(tester);
      await foreground(tester);
      expect(locked(), isFalse);
      expect(auth.asked, 1);
      await data.unmount(tester);
    });
  });

  group('SecurityPage', () {
    Future<void> pumpPage(WidgetTester tester, TestData data) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(data.database),
            deviceAuthProvider.overrideWithValue(auth),
          ],
          child: const MaterialApp(home: SecurityPage()),
        ),
      );
      await data.waitFor(tester, find.text(Strings.lockOff));
    }

    /// Picks [label] and lets the setting reach the page
    Future<void> choose(WidgetTester tester, String label) async {
      await tester.runAsync(() async {
        await tester.tap(find.text(label));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pump();
    }

    testWidgets('turns the lock on after unlocking the phone once', (
      tester,
    ) async {
      final data = TestData();
      await pumpPage(tester, data);

      await choose(tester, Strings.lockAfter(5));
      expect(auth.asked, 1);
      expect(
        await tester.runAsync(() => data.database.setting(appLockKey)),
        '5',
      );

      await choose(tester, Strings.lockAfter(15));
      expect(auth.asked, 1); // changing the time doesn't ask again
      expect(
        await tester.runAsync(() => data.database.setting(appLockKey)),
        '15',
      );

      await choose(tester, Strings.lockOff);
      expect(
        await tester.runAsync(() => data.database.setting(appLockKey)),
        isNull,
      );
      await data.unmount(tester);
    });

    testWidgets('needs a screen lock on the phone', (tester) async {
      final data = TestData();
      auth.available = false;
      await pumpPage(tester, data);

      await choose(tester, Strings.lockImmediately);
      await tester.pump();
      expect(find.text(Strings.lockNeedsScreenLock), findsOneWidget);
      expect(
        await tester.runAsync(() => data.database.setting(appLockKey)),
        isNull,
      );
      await data.unmount(tester);
    });
  });

  test('DeviceAuth can ask again after the dialog failed', () async {
    final platform = _FlakyPlatform();
    LocalAuthPlatform.instance = platform;
    final auth = DeviceAuth();

    expect(await auth.authenticate(), isFalse);
    expect(auth.busy, isFalse);
    expect(await auth.authenticate(), isTrue);
    expect(platform.calls, 2);
  });
}
