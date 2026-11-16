import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/features/company/certificate_status.dart';
import 'package:xhandler_mobile/strings.dart';

void main() {
  final now = DateTime.utc(2026, 11, 15);

  test('certificateWarning warns 30 days ahead and once expired', () {
    expect(certificateWarning(DateTime.utc(2027, 3), now: now), isNull);
    expect(
      certificateWarning(DateTime.utc(2026, 12, 10), now: now),
      Strings.certificateExpiresSoon,
    );
    expect(
      certificateWarning(DateTime.utc(2026, 11, 14), now: now),
      Strings.certificateExpired,
    );
  });
}
