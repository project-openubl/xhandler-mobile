import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/widgets/readable_width.dart';

void main() {
  /// The page's rectangle on a [screen], and the side padding it gets
  Future<(Rect, EdgeInsets)> page(
    WidgetTester tester,
    Size screen, {
    EdgeInsets padding = EdgeInsets.zero,
  }) async {
    tester.view.physicalSize = screen;
    tester.view.devicePixelRatio = 1;
    tester.view.padding = FakeViewPadding(
      left: padding.left,
      right: padding.right,
    );
    addTearDown(tester.view.reset);
    late EdgeInsets seen;
    await tester.pumpWidget(
      MaterialApp(
        builder: (_, child) => ReadableWidth(child: child!),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              seen = MediaQuery.paddingOf(context);
              return const Text('Página');
            },
          ),
        ),
      ),
    );
    return (tester.getRect(find.byType(Scaffold)), seen);
  }

  testWidgets('phones and windows up to 840 use the whole width', (
    tester,
  ) async {
    expect((await page(tester, const Size(412, 900))).$1.width, 412);
    expect((await page(tester, const Size(840, 900))).$1.width, 840);
  });

  testWidgets('wider screens centre the pages at 840', (tester) async {
    final (rect, _) = await page(tester, const Size(1280, 800));
    expect(rect, const Rect.fromLTWH(220, 0, 840, 800));
  });

  testWidgets('side insets the centring covers are taken off', (tester) async {
    // 30 of each side are outside the column; a 48 navigation bar keeps 18
    final (_, padding) = await page(
      tester,
      const Size(900, 400),
      padding: const EdgeInsets.only(left: 20, right: 48),
    );
    expect(padding.left, 0);
    expect(padding.right, 18);
  });
}
