import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xhandler_mobile/widgets/page_list_view.dart';

void main() {
  testWidgets('a page starts under its app bar and ends above the '
      'navigation bar', (tester) async {
    tester.view.physicalSize = const Size(412, 900);
    tester.view.devicePixelRatio = 1;
    // Edge-to-edge: the status bar and the navigation bar overlap the app
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 48);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Boleta')),
          body: PageListView(
            children: [
              const Text('Serie'),
              const SizedBox(height: 2000),
              FilledButton(onPressed: () {}, child: const Text('Emitir')),
            ],
          ),
        ),
      ),
    );

    // The app bar already takes the status bar
    expect(
      tester.getTopLeft(find.text('Serie')).dy,
      tester.getBottomLeft(find.byType(AppBar)).dy + 16,
    );

    await tester.drag(find.byType(ListView), const Offset(0, -5000));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.byType(FilledButton)).dy, 900 - 48 - 16);
  });
}
