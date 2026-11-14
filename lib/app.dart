import 'package:material_ui/material_ui.dart';

import 'router.dart';
import 'strings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Strings.appTitle,
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      routerConfig: router,
    );
  }
}
