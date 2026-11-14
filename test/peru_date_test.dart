import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/peru_date.dart';

void main() {
  test('peruToday is the date in UTC-5', () {
    expect(peruToday(DateTime.utc(2026, 11, 14, 3, 30)), '2026-11-13');
    expect(peruToday(DateTime.utc(2026, 11, 14, 5)), '2026-11-14');
    expect(peruToday(DateTime.utc(2027, 1, 1, 4, 59)), '2026-12-31');
  });
}
