import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prayer_time.dart';
import '../services/prayer_time_service.dart';
import '../services/storage_service.dart';
import 'clock_provider.dart';

final prayerTimeProvider = FutureProvider<PrayerTime>((ref) async {
  final nowDayKey = ref.watch(
    clockProvider.select((s) => DateTime(s.now.year, s.now.month, s.now.day)),
  );
  final currentDate = nowDayKey;
  final storageService = StorageService();
  final service = PrayerTimeService(storageService);
  return service.fetchWaktuSholat(currentDate);
});
