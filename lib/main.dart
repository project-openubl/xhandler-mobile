import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const App());
}
