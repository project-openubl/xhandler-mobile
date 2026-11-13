import 'package:material_ui/material_ui.dart';

import 'features/diagnostics/sunat_beta_check_page.dart';
import 'strings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const SunatBetaCheckPage(),
    );
  }
}
