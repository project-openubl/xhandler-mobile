import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app_log.dart';

import 'features/appearance/theme_mode.dart';
import 'features/lock/app_lock.dart';
import 'notifications.dart';
import 'router.dart';
import 'strings.dart';
import 'theme/status_colors.dart';
import 'widgets/readable_width.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key, this.initialThemeMode = ThemeMode.system});

  /// The stored theme mode, read before the first frame
  final ThemeMode initialThemeMode;

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final _router = buildRouter();

  @override
  void initState() {
    super.initState();
    Notifications.onOpenDocument = _openDocument;
    unawaited(_listenToNotifications());
  }

  /// Taps on notifications open their document, also when a tap started
  /// the app
  Future<void> _listenToNotifications() async {
    try {
      await Notifications.initialize();
      final launch = await Notifications.launchDocument();
      if (launch != null) _openDocument(launch);
    } on Object catch (error, stack) {
      AppLog.error('Notifications', error, stack);
    }
  }

  void _openDocument(String documentId) =>
      unawaited(_router.push(Routes.document(documentId)));

  @override
  void dispose() {
    Notifications.onOpenDocument = null;
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Strings.appTitle,
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // Material's own colors; light or dark as the user picked, by default
      // following the phone's setting
      themeMode: appThemeMode(ref, widget.initialThemeMode),
      theme: ThemeData(extensions: const [StatusColors.light]),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: const [StatusColors.dark],
      ),
      routerConfig: _router,
      builder: (_, child) => ReadableWidth(child: AppLock(child: child!)),
    );
  }
}
