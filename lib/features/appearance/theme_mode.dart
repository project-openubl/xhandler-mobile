import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../data/providers.dart';

/// Device setting with the [ThemeMode] the user picked (`light` or `dark`);
/// not set when the app follows the phone's setting
const themeModeKey = 'theme_mode';

/// The mode a stored setting means; an unknown value follows the phone
/// rather than failing
ThemeMode themeModeFrom(String? value) =>
    ThemeMode.values.asNameMap()[value] ?? ThemeMode.system;

final themeModeProvider = StreamProvider<ThemeMode>(
  (ref) =>
      ref.watch(databaseProvider).watchSetting(themeModeKey).map(themeModeFrom),
);

/// The app's mode: [initial] (read before the first frame, so the app
/// doesn't flash the phone's mode) until the setting streams in
ThemeMode appThemeMode(WidgetRef ref, ThemeMode initial) =>
    ref.watch(themeModeProvider).value ?? initial;

/// Saves [mode]; [ThemeMode.system] removes the setting
Future<void> setThemeMode(AppDatabase database, ThemeMode mode) =>
    mode == ThemeMode.system
    ? database.deleteSetting(themeModeKey)
    : database.setSetting(themeModeKey, mode.name);
