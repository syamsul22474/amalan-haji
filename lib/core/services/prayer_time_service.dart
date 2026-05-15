import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/prayer_time.dart';
import 'storage_service.dart';

class PrayerTimeService {
  static const _baseUrl = 'https://api.aladhan.com/v1/timingsByCity';
  final Dio _dio = Dio();
  final StorageService _storageService;

  PrayerTimeService(this._storageService);

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
        final timings = response.data['data']['timings'] as Map<String, dynamic>;
        // Simpan ke cache jika berhasil
        await _storageService.setCachedPrayerTime(tanggal, timings);
        return PrayerTime.fromJson(timings, tanggal);
      }
      throw Exception('Gagal mengambil jadwal sholat');
    } on DioException {
      // Jika offline, periksa cache lokal terlebih dahulu
      return await _getCachedOrDefault(tanggal);
    } catch (e) {
      return await _getCachedOrDefault(tanggal);
    }
  }

  Future<PrayerTime> _getCachedOrDefault(DateTime tanggal) async {
    final cached = await _storageService.getCachedPrayerTime(tanggal);
    if (cached != null) {
      return PrayerTime.fromJson(cached, tanggal);
    }
    return _getDefaultPrayerTime(tanggal);
  }

  PrayerTime _getDefaultPrayerTime(DateTime tanggal) {
    return PrayerTime(
      fajr: DateTime(tanggal.year, tanggal.month, tanggal.day, 4, 14),
      syuruq: DateTime(tanggal.year, tanggal.month, tanggal.day, 5, 39),
      dhuhr: DateTime(tanggal.year, tanggal.month, tanggal.day, 12, 18),
      asr: DateTime(tanggal.year, tanggal.month, tanggal.day, 15, 32),
      maghrib: DateTime(tanggal.year, tanggal.month, tanggal.day, 18, 56),
      isha: DateTime(tanggal.year, tanggal.month, tanggal.day, 20, 26),
      date: tanggal,
    );
  }
}
