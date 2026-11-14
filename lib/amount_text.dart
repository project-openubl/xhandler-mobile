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
