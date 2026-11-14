/// Amounts are kept as text so they stay exact (UBL: up to 12 integer
/// digits and 10 decimals)
library;

final _amount = RegExp(r'^(\d{1,12})(?:\.(\d{1,10}))?$');

/// A typed amount normalized ("4,50" → "4.50", "007" → "7"), or `null` when
/// it isn't a positive amount
String? parseAmount(String text) {
  final match = _amount.firstMatch(text.trim().replaceAll(',', '.'));
  if (match == null) return null;
  final integer = match[1]!.replaceFirst(RegExp(r'^0+(?=\d)'), '');
  final decimals = match[2];
  final amount = decimals == null ? integer : '$integer.$decimals';
  return RegExp(r'^[0.]+$').hasMatch(amount) ? null : amount;
}

/// A percentage as the fraction xbuilder expects, exactly: "17" → "0.17",
/// "12.5" → "0.125"
String percentToFraction(String percent) {
  final [integer, decimals] = percent.contains('.')
      ? percent.split('.')
      : [percent, ''];
  final padded = integer.padLeft(3, '0');
  final whole = padded
      .substring(0, padded.length - 2)
      .replaceFirst(RegExp(r'^0+(?=\d)'), '');
  return '$whole.${padded.substring(padded.length - 2)}$decimals';
}

/// A fraction as a percentage, exactly: "0.17" → "17", "0.125" → "12.5"
String fractionToPercent(String fraction) {
  final [integer, decimals] = fraction.contains('.')
      ? fraction.split('.')
      : [fraction, ''];
  final padded = decimals.padRight(2, '0');
  final whole = '$integer${padded.substring(0, 2)}'.replaceFirst(
    RegExp(r'^0+(?=\d)'),
    '',
  );
  final rest = padded.substring(2);
  return rest.isEmpty ? whole : '$whole.$rest';
}

/// [amount] rounded half-up to [scale] decimals: "30.3000000000" → "30.30"
String roundAmount(String amount, [int scale = 2]) {
  final negative = amount.startsWith('-');
  final digits = negative ? amount.substring(1) : amount;
  final [integer, decimals] = digits.contains('.')
      ? digits.split('.')
      : [digits, ''];
  final padded = decimals.padRight(scale + 1, '0');
  var units = BigInt.parse('$integer${padded.substring(0, scale)}');
  if (int.parse(padded[scale]) >= 5) units += BigInt.one;
  final text = units.toString().padLeft(scale + 1, '0');
  final split = text.length - scale;
  return '${negative ? '-' : ''}${text.substring(0, split)}.${text.substring(split)}';
}

/// [amount] in cents, to compare and add amounts exactly
BigInt toCents(String amount) =>
    BigInt.parse(roundAmount(amount).replaceAll('.', ''));

/// [cents] as an amount: 59050 → "590.50"
String fromCents(BigInt cents) {
  final text = cents.abs().toString().padLeft(3, '0');
  final split = text.length - 2;
  return '${cents.isNegative ? '-' : ''}${text.substring(0, split)}.${text.substring(split)}';
}

/// An amount as people read it: "S/ 59.00", "US$ 12.50"
String formatMoney(String moneda, String amount) {
  final symbol = switch (moneda) {
    'PEN' => 'S/',
    'USD' => r'US$',
    _ => moneda,
  };
  return '$symbol ${roundAmount(amount)}';
}

/// The exact sum of two non-negative amounts, e.g. a line's taxable base and
/// its taxes: "38.1355" + "15.6649" → "53.8004"
String addAmounts(String a, String b) {
  (String, String) parts(String amount) => amount.contains('.')
      ? (amount.split('.')[0], amount.split('.')[1])
      : (amount, '');
  final (aInteger, aDecimals) = parts(a);
  final (bInteger, bDecimals) = parts(b);
  final scale = aDecimals.length > bDecimals.length
      ? aDecimals.length
      : bDecimals.length;
  final sum =
      BigInt.parse('$aInteger${aDecimals.padRight(scale, '0')}') +
      BigInt.parse('$bInteger${bDecimals.padRight(scale, '0')}');
  if (scale == 0) return '$sum';
  final text = sum.toString().padLeft(scale + 1, '0');
  final split = text.length - scale;
  return '${text.substring(0, split)}.${text.substring(split)}';
}
