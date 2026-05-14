import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prayer_time.dart';
import '../services/prayer_time_service.dart';
import 'clock_provider.dart';

final prayerTimeProvider = FutureProvider<PrayerTime>((ref) async {
  final currentDate = ref.watch(clockProvider);
  final service = PrayerTimeService();
  return service.fetchWaktuSholat(currentDate);
});
