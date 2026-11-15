import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'app_log.dart';

import 'features/lock/app_lock.dart';
import 'notifications.dart';
import 'router.dart';
import 'strings.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      routerConfig: _router,
      builder: (_, child) => AppLock(child: child!),
    );
  }
}
