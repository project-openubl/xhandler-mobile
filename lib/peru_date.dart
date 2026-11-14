/// Today's date in Peru (UTC-5, no daylight saving time) as "YYYY-MM-DD",
/// whatever the device's time zone: SUNAT rejects documents issued "in the
/// future".
String peruToday([DateTime? now]) {
  final peru = (now ?? DateTime.now()).toUtc().subtract(
    const Duration(hours: 5),
  );
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${peru.year}-${twoDigits(peru.month)}-${twoDigits(peru.day)}';
}
