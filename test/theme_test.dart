import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/tables.dart';
import 'package:xhandler_mobile/features/document/document_status.dart';
import 'package:xhandler_mobile/theme/status_colors.dart';

void main() {
  testWidgets('status chips use the status colors of the theme', (
    tester,
  ) async {
    for (final (brightness, colors) in [
      (Brightness.light, StatusColors.light),
      (Brightness.dark, StatusColors.dark),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness, extensions: [colors]),
          home: const Scaffold(
            body: DocumentStatusChip(DocumentStatus.accepted),
          ),
        ),
      );
      await tester.pumpAndSettle(); // MaterialApp animates theme changes
      final label = tester.widget<Text>(
        find.text(DocumentStatus.accepted.label),
      );
      expect(label.style?.color, colors.success);
    }
  });
}
