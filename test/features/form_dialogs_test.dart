import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/features/document/invoice_draft.dart';
import 'package:xhandler_mobile/features/document/invoice_form_parts.dart';
import 'package:xhandler_mobile/strings.dart';

/// A common phone (about 393×698 dp) with the soft keyboard open; it takes
/// about half of the height in landscape
void smallPhoneWithKeyboard(WidgetTester tester, {bool landscape = false}) {
  const ratio = 2.75;
  tester.view.physicalSize = landscape
      ? const Size(1920, 1080)
      : const Size(1080, 1920);
  tester.view.devicePixelRatio = ratio;
  tester.view.viewInsets = FakeViewPadding(
    bottom: (landscape ? 200 : 300) * ratio,
  );
  addTearDown(tester.view.reset);
}

/// Shows [dialog]; the returned future completes with what it pops
Future<Future<T?>> showTestDialog<T>(WidgetTester tester, Widget dialog) async {
  late Future<T?> result;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => result = showDialog<T>(
              context: context,
              builder: (_) => dialog,
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return result;
}

void main() {
  for (final (name, landscape, textScale) in [
    ('portrait', false, 1.0),
    ('landscape', true, 1.0),
    ('large font', false, 2.0),
  ]) {
    testWidgets('the free line dialog fits with the keyboard open ($name)', (
      tester,
    ) async {
      smallPhoneWithKeyboard(tester, landscape: landscape);
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final result = await showTestDialog<DraftLine>(
        tester,
        const LineDialog(line: null, igvTipo: '10'),
      );
      expect(tester.takeException(), isNull);

      // Empty: every field shows its error
      await tester.ensureVisible(find.text(Strings.add));
      await tester.tap(find.text(Strings.add));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(Strings.required), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Servicio');
      await tester.enterText(fields.at(2), '10');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(Strings.add));
      await tester.tap(find.text(Strings.add));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final line = await result;
      expect(line?.descripcion, 'Servicio');
      expect(line?.precio, '10');
    });
  }

  testWidgets('the cuota dialog fits with the keyboard open', (tester) async {
    smallPhoneWithKeyboard(tester, landscape: true);
    await showTestDialog<DraftCuota>(tester, const CuotaDialog());
    await tester.ensureVisible(find.text(Strings.add));
    await tester.tap(find.text(Strings.add));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text(Strings.invalidPrecio), findsOneWidget);
  });
}
