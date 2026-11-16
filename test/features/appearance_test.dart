import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/providers.dart';
import 'package:xhandler_mobile/features/appearance/appearance_page.dart';
import 'package:xhandler_mobile/features/appearance/theme_mode.dart';
import 'package:xhandler_mobile/strings.dart';

import '../helpers.dart';

void main() {
  setUp(() {
    final dispatcher = TestWidgetsFlutterBinding.instance.platformDispatcher;
    dispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(dispatcher.clearPlatformBrightnessTestValue);
  });

  /// The page in an app that takes its mode from [appThemeMode], as `App`
  Future<void> pumpPage(
    WidgetTester tester,
    TestData data, {
    ThemeMode initial = ThemeMode.system,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(data.database)],
        child: Consumer(
          builder: (_, ref, _) => MaterialApp(
            theme: ThemeData(),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: appThemeMode(ref, initial),
            home: const AppearancePage(),
          ),
        ),
      ),
    );
  }

  ThemeMode picked(WidgetTester tester) => tester
      .widget<RadioGroup<ThemeMode>>(find.byType(RadioGroup<ThemeMode>))
      .groupValue!;

  /// Waits until the page shows the stored [mode]
  Future<void> waitForPicked(WidgetTester tester, ThemeMode mode) async {
    for (var i = 0; i < 50 && picked(tester) != mode; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump();
    }
    expect(picked(tester), mode);
    await tester.pumpAndSettle(); // MaterialApp animates theme changes
  }

  /// Picks [label] and lets the setting reach the app
  Future<void> choose(WidgetTester tester, String label, ThemeMode mode) async {
    await tester.tap(find.text(label));
    await waitForPicked(tester, mode);
  }

  Brightness brightness(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(AppearancePage))).brightness;

  testWidgets('follows the phone until the user picks a mode', (tester) async {
    final data = TestData();
    await pumpPage(tester, data);
    await tester.pumpAndSettle();
    expect(brightness(tester), Brightness.dark);

    await choose(tester, Strings.themeLight, ThemeMode.light);
    expect(await data.database.setting(themeModeKey), 'light');
    expect(brightness(tester), Brightness.light);

    await choose(tester, Strings.themeDark, ThemeMode.dark);
    expect(await data.database.setting(themeModeKey), 'dark');
    expect(brightness(tester), Brightness.dark);

    await choose(tester, Strings.themeSystem, ThemeMode.system);
    expect(await data.database.setting(themeModeKey), isNull);
    expect(brightness(tester), Brightness.dark);
    await data.unmount(tester);
  });

  testWidgets('a stored mode applies from the first frame', (tester) async {
    final data = TestData();
    await setThemeMode(data.database, ThemeMode.light);
    final initial = themeModeFrom(await data.database.setting(themeModeKey));
    await pumpPage(tester, data, initial: initial);
    // No settling: the phone's dark mode never shows
    expect(brightness(tester), Brightness.light);

    await waitForPicked(tester, ThemeMode.light);
    expect(brightness(tester), Brightness.light);
    await data.unmount(tester);
  });

  test('an unknown stored value follows the phone', () {
    expect(themeModeFrom('sepia'), ThemeMode.system);
    expect(themeModeFrom(null), ThemeMode.system);
    expect(themeModeFrom('dark'), ThemeMode.dark);
  });
}
