import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/amount_text.dart';

void main() {
  test('parseAmount normalizes typed amounts', () {
    expect(parseAmount('4.50'), '4.50');
    expect(parseAmount(' 4,50 '), '4.50');
    expect(parseAmount('0004.5'), '4.5');
    expect(parseAmount('0.25'), '0.25');
    expect(parseAmount('0'), isNull);
    expect(parseAmount('0.00'), isNull);
    expect(parseAmount('-1'), isNull);
    expect(parseAmount('1.2.3'), isNull);
    expect(parseAmount('1234567890123'), isNull); // 13 integer digits
  });

  test('percentToFraction moves the decimal point exactly', () {
    expect(percentToFraction('17'), '0.17');
    expect(percentToFraction('5'), '0.05');
    expect(percentToFraction('12.5'), '0.125');
    expect(percentToFraction('100'), '1.00');
    expect(percentToFraction('250'), '2.50');
  });
}
