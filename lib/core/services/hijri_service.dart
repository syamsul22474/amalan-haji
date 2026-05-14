import 'package:hijri/hijri_calendar.dart';

class HijriService {
  /// Mendapatkan tanggal Hijriah (Umm al-Qura) berdasarkan tanggal Masehi dan koreksi (adjustment).
  /// [adjustment] adalah jumlah hari untuk menggeser kalender (misal: -1, 0, +1).
  HijriCalendar getHijriDate(DateTime date, int adjustment) {
    // Cara paling akurat untuk melakukan penyesuaian adalah dengan menggeser 
    // tanggal Masehi sebelum dikonversi ke Hijriah.
    final adjustedDate = date.add(Duration(days: adjustment));
    return HijriCalendar.fromDate(adjustedDate);
  }

  /// Memeriksa apakah suatu tanggal berada dalam rentang Hari Haji (8-13 Dzulhijjah).
  bool isHajjDay(HijriCalendar hijri) {
    return hijri.hMonth == 12 && hijri.hDay >= 8 && hijri.hDay <= 13;
  }
}
