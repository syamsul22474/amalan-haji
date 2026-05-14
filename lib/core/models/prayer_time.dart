class PrayerTime {
  final DateTime fajr;
  final DateTime syuruq;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime date;

  const PrayerTime({
    required this.fajr,
    required this.syuruq,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json, DateTime date) {
    DateTime parseTime(String timeString) {
      // The Aladhan API might return something like "04:32 (AST)"
      final cleanTime = timeString.split(' ')[0];
      final parts = cleanTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(date.year, date.month, date.day, hour, minute);
    }

    return PrayerTime(
      fajr: parseTime(json['Fajr'] as String),
      syuruq: parseTime(json['Sunrise'] as String),
      dhuhr: parseTime(json['Dhuhr'] as String),
      asr: parseTime(json['Asr'] as String),
      maghrib: parseTime(json['Maghrib'] as String),
      isha: parseTime(json['Isha'] as String),
      date: date,
    );
  }
}
