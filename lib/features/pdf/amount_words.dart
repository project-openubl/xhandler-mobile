import '../../amount_text.dart';

/// The total in words, as printed documents show it (SUNAT legend 1000):
/// "45.60", "PEN" → "CUARENTA Y CINCO CON 60/100 SOLES"
String amountInWords(String amount, String moneda) {
  final cents = toCents(amount);
  final units = cents ~/ BigInt.from(100);
  final fraction = (cents % BigInt.from(100)).toInt().toString().padLeft(
    2,
    '0',
  );
  final currency = switch (moneda) {
    'PEN' => 'SOLES',
    'USD' => 'DÓLARES AMERICANOS',
    'EUR' => 'EUROS',
    _ => moneda,
  };
  return '${_number(units.toInt())} CON $fraction/100 $currency';
}

const _units = [
  'CERO',
  'UNO',
  'DOS',
  'TRES',
  'CUATRO',
  'CINCO',
  'SEIS',
  'SIETE',
  'OCHO',
  'NUEVE',
  'DIEZ',
  'ONCE',
  'DOCE',
  'TRECE',
  'CATORCE',
  'QUINCE',
  'DIECISÉIS',
  'DIECISIETE',
  'DIECIOCHO',
  'DIECINUEVE',
  'VEINTE',
  'VEINTIUNO',
  'VEINTIDÓS',
  'VEINTITRÉS',
  'VEINTICUATRO',
  'VEINTICINCO',
  'VEINTISÉIS',
  'VEINTISIETE',
  'VEINTIOCHO',
  'VEINTINUEVE',
];

const _tens = [
  '',
  '',
  '',
  'TREINTA',
  'CUARENTA',
  'CINCUENTA',
  'SESENTA',
  'SETENTA',
  'OCHENTA',
  'NOVENTA',
];

const _hundreds = [
  '',
  'CIENTO',
  'DOSCIENTOS',
  'TRESCIENTOS',
  'CUATROCIENTOS',
  'QUINIENTOS',
  'SEISCIENTOS',
  'SETECIENTOS',
  'OCHOCIENTOS',
  'NOVECIENTOS',
];

String _number(int n) {
  if (n < 30) return _units[n];
  if (n < 100) {
    final unit = n % 10;
    return unit == 0 ? _tens[n ~/ 10] : '${_tens[n ~/ 10]} Y ${_units[unit]}';
  }
  if (n < 1000) {
    if (n == 100) return 'CIEN';
    final rest = n % 100;
    return rest == 0
        ? _hundreds[n ~/ 100]
        : '${_hundreds[n ~/ 100]} ${_number(rest)}';
  }
  if (n < 1000000) {
    final thousands = n ~/ 1000;
    final rest = n % 1000;
    // "UN MIL" is "MIL"; "VEINTIUNO MIL" is "VEINTIÚN MIL"
    final head = thousands == 1 ? 'MIL' : '${_apocope(_number(thousands))} MIL';
    return rest == 0 ? head : '$head ${_number(rest)}';
  }
  final millions = n ~/ 1000000;
  final rest = n % 1000000;
  final head = millions == 1
      ? 'UN MILLÓN'
      : '${_apocope(_number(millions))} MILLONES';
  return rest == 0 ? head : '$head ${_number(rest)}';
}

/// "UNO" before "MIL" or "MILLONES" is "UN": "VEINTIUNO" → "VEINTIÚN"
String _apocope(String words) => words.endsWith('VEINTIUNO')
    ? '${words.substring(0, words.length - 9)}VEINTIÚN'
    : words.endsWith('UNO')
    ? '${words.substring(0, words.length - 3)}UN'
    : words;
