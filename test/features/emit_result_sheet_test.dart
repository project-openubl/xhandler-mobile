import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/data/database.dart';
import 'package:xhandler_mobile/features/document/emit_flow.dart';

void main() {
  testWidgets('the result sheet keeps its buttons above the navigation bar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(412, 900);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 48);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showModalBottomSheet<bool>(
                  context: context,
                  builder: (_) =>
                      const EmitResultSheet(status: DocumentStatus.accepted),
                ),
                child: const Text('Emitir'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Emitir'));
    await tester.pumpAndSettle();

    expect(tester.getBottomLeft(find.byType(FilledButton)).dy, 900 - 48 - 24);
  });
}
