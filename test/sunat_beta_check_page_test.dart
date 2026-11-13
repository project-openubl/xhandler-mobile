import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/features/diagnostics/sunat_beta_check_page.dart';
import 'package:xhandler_mobile/strings.dart';

void main() {
  testWidgets('shows the check and its button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SunatBetaCheckPage()));

    expect(find.text(Strings.sunatBetaCheckTitle), findsOneWidget);
    expect(find.text(Strings.sunatBetaCheckRun), findsOneWidget);
  });
}
