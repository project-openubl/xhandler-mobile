import 'package:material_ui/material_ui.dart';

import '../strings.dart';

/// Reminds that documents go to SUNAT beta
class TestModeBanner extends StatelessWidget {
  const TestModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          Strings.testMode,
          style: TextStyle(color: colors.onTertiaryContainer),
        ),
      ),
    );
  }
}
