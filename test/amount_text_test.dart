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

  test('fractionToPercent is the inverse of percentToFraction', () {
    expect(fractionToPercent('0.17'), '17');
    expect(fractionToPercent('0.125'), '12.5');
    expect(fractionToPercent('1.00'), '100');
    for (final percent in ['17', '5', '12.5', '250']) {
      expect(fractionToPercent(percentToFraction(percent)), percent);
    }
  });

  test('roundAmount rounds half up', () {
    expect(roundAmount('30.300000000000000000000000000'), '30.30');
    expect(roundAmount('118'), '118.00');
    expect(roundAmount('0.005'), '0.01');
    expect(roundAmount('2.344'), '2.34');
    expect(roundAmount('9.995'), '10.00');
    expect(roundAmount('-1.5'), '-1.50');
  });

  test('toCents', () {
    expect(toCents('700'), BigInt.from(70000));
    expect(toCents('700.004'), BigInt.from(70000));
    expect(toCents('590.5'), BigInt.from(59050));
  });

  test('addAmounts is exact', () {
    expect(
      addAmounts(
        '38.135593220338983050847457627',
        '15.664928292046936114732724902',
      ),
      '53.800521512385919165580182529',
    );
    expect(addAmounts('0.5', '0.25'), '0.75');
    expect(addAmounts('1', '2'), '3');
    expect(addAmounts('0.05', '0'), '0.05');
  });
}
