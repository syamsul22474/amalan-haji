import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/prayer_time.dart';

class PrayerTimeService {
  static const _baseUrl = 'https://api.aladhan.com/v1/timingsByCity';
  final Dio _dio = Dio();

  Future<PrayerTime> fetchWaktuSholat(DateTime tanggal) async {
    final dateStr = DateFormat('dd-MM-yyyy').format(tanggal);

    try {
      final response = await _dio.get(_baseUrl, queryParameters: {
        'city': 'Makkah',
        'country': 'SA',
        'method': '4', // Umm Al-Qura (resmi Saudi)
        'date': dateStr,
      });

      if (response.statusCode == 200) {
        final timings = response.data['data']['timings'];
        return PrayerTime.fromJson(timings as Map<String, dynamic>, tanggal);
      }
      throw Exception('Gagal mengambil jadwal sholat');
    } on DioException {
      // Jika offline, kembalikan data fallback default
      return _getDefaultPrayerTime(tanggal);
    } catch (e) {
      return _getDefaultPrayerTime(tanggal);
    }
  }

  PrayerTime _getDefaultPrayerTime(DateTime tanggal) {
    return PrayerTime(
      fajr: DateTime(tanggal.year, tanggal.month, tanggal.day, 4, 32),
      syuruq: DateTime(tanggal.year, tanggal.month, tanggal.day, 5, 58),
      dhuhr: DateTime(tanggal.year, tanggal.month, tanggal.day, 12, 15),
      asr: DateTime(tanggal.year, tanggal.month, tanggal.day, 15, 37),
      maghrib: DateTime(tanggal.year, tanggal.month, tanggal.day, 18, 32),
      isha: DateTime(tanggal.year, tanggal.month, tanggal.day, 20, 2),
      date: tanggal,
    );
  }
}
