/// Today's date in Peru (UTC-5, no daylight saving time) as "YYYY-MM-DD",
/// whatever the device's time zone: SUNAT rejects documents issued "in the
/// future".
String peruToday([DateTime? now]) {
  final peru = (now ?? DateTime.now()).toUtc().subtract(
    const Duration(hours: 5),
  );
  return isoDate(peru);
}

/// "YYYY-MM-DD" of [date]'s calendar day, e.g. one picked in a date picker
String isoDate(DateTime date) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
}
