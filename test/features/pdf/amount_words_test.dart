import 'package:flutter_test/flutter_test.dart';
import 'package:xhandler_mobile/features/pdf/amount_words.dart';

void main() {
  test('amounts in words, as SUNAT legend 1000', () {
    final cases = {
      '0.50': 'CERO CON 50/100 SOLES',
      '1': 'UNO CON 00/100 SOLES',
      '21': 'VEINTIUNO CON 00/100 SOLES',
      '45.60': 'CUARENTA Y CINCO CON 60/100 SOLES',
      '100': 'CIEN CON 00/100 SOLES',
      '118': 'CIENTO DIECIOCHO CON 00/100 SOLES',
      '1000': 'MIL CON 00/100 SOLES',
      '1203.6': 'MIL DOSCIENTOS TRES CON 60/100 SOLES',
      '21000': 'VEINTIÚN MIL CON 00/100 SOLES',
      '31000': 'TREINTA Y UN MIL CON 00/100 SOLES',
      '101000': 'CIENTO UN MIL CON 00/100 SOLES',
      '1000000': 'UN MILLÓN CON 00/100 SOLES',
      '2500000.99': 'DOS MILLONES QUINIENTOS MIL CON 99/100 SOLES',
    };
    for (final MapEntry(key: amount, value: words) in cases.entries) {
      expect(amountInWords(amount, 'PEN'), words, reason: amount);
    }
    expect(amountInWords('10', 'USD'), 'DIEZ CON 00/100 DÓLARES AMERICANOS');
  });
}
