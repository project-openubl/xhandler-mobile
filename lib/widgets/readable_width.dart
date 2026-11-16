import 'dart:math';

import 'package:material_ui/material_ui.dart';

/// Keeps the app at a readable width on tablets and wide windows, so forms
/// and lists don't stretch across the screen. Above Material's "expanded"
/// width (840 dp) the app is centred at that width.
class ReadableWidth extends StatelessWidget {
  const ReadableWidth({super.key, required this.child});

  static const maxWidth = 840.0;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (media.size.width <= maxWidth) return child;
    // The column is this far from each side of the screen: side insets
    // (cut-outs, a navigation bar in landscape) within it don't reach it
    final gap = (media.size.width - maxWidth) / 2;
    EdgeInsets inside(EdgeInsets insets) => insets.copyWith(
      left: max(0, insets.left - gap),
      right: max(0, insets.right - gap),
    );
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Center(
        child: MediaQuery(
          // So layout that reads MediaQuery (breakpoints, dialogs) sees the
          // column, not the screen
          data: media.copyWith(
            size: Size(maxWidth, media.size.height),
            padding: inside(media.padding),
            viewPadding: inside(media.viewPadding),
            systemGestureInsets: inside(media.systemGestureInsets),
            // A foldable's hinge is in screen coordinates
            displayFeatures: const [],
          ),
          child: SizedBox(width: maxWidth, child: child),
        ),
      ),
    );
  }
}
