import 'package:material_ui/material_ui.dart';

/// Scrolling body of a page (a [Scaffold]'s body): [children] with a 16 dp
/// margin, ending above the system navigation bar. It already pads for the
/// system insets, so nothing inside it needs a [SafeArea]
class PageListView extends StatelessWidget {
  const PageListView({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16) + MediaQuery.paddingOf(context),
    children: children,
  );
}
