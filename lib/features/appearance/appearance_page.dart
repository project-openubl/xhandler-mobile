import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/providers.dart';
import '../../strings.dart';
import 'theme_mode.dart';

/// Picks light or dark colors, or the phone's setting
class AppearancePage extends ConsumerWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.appearance)),
      body: ListView(
        children: [
          const ListTile(title: Text(Strings.themeMode)),
          RadioGroup<ThemeMode>(
            groupValue: mode,
            onChanged: (choice) =>
                setThemeMode(ref.read(databaseProvider), choice!),
            child: const Column(
              children: [
                RadioListTile(
                  value: ThemeMode.system,
                  secondary: Icon(Icons.brightness_auto),
                  title: Text(Strings.themeSystem),
                  subtitle: Text(Strings.themeSystemHelp),
                ),
                RadioListTile(
                  value: ThemeMode.light,
                  secondary: Icon(Icons.light_mode),
                  title: Text(Strings.themeLight),
                ),
                RadioListTile(
                  value: ThemeMode.dark,
                  secondary: Icon(Icons.dark_mode),
                  title: Text(Strings.themeDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
