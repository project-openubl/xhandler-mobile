import 'package:material_ui/material_ui.dart';

/// Colors that mean something besides Material's error, for light and dark:
/// e.g. a document accepted or waiting for SUNAT. The hardcoded green and
/// amber they replace were unreadable on dark surfaces.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({required this.success, required this.warning});

  static const light = StatusColors(
    success: Color(0xFF2E7D32), // Material green 800
    // Amber-brown with 4.5:1 contrast on white: Material's amber and orange
    // shades are too light for text
    warning: Color(0xFFB45309),
  );

  static const dark = StatusColors(
    success: Color(0xFF81C784), // Material green 300
    warning: Color(0xFFFFB74D), // Material orange 300
  );

  final Color success;
  final Color warning;

  /// The theme's status colors; light ones in widget tests that use a plain
  /// `ThemeData`
  static StatusColors of(BuildContext context) =>
      Theme.of(context).extension<StatusColors>() ?? light;

  @override
  StatusColors copyWith({Color? success, Color? warning}) => StatusColors(
    success: success ?? this.success,
    warning: warning ?? this.warning,
  );

  @override
  StatusColors lerp(StatusColors? other, double t) => other == null
      ? this
      : StatusColors(
          success: Color.lerp(success, other.success, t)!,
          warning: Color.lerp(warning, other.warning, t)!,
        );
}
