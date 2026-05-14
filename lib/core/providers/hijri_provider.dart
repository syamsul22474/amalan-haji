import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import '../services/hijri_service.dart';
import '../services/storage_service.dart';
import 'clock_provider.dart';

/// Provider untuk HijriService (Logic)
final hijriServiceProvider = Provider((ref) => HijriService());

/// Provider untuk mengelola nilai koreksi (adjustment) Hijriah
final hijriAdjustmentProvider = StateNotifierProvider<HijriAdjustmentNotifier, int>((ref) {
  return HijriAdjustmentNotifier();
});

class HijriAdjustmentNotifier extends StateNotifier<int> {
  final StorageService _storage = StorageService();

  HijriAdjustmentNotifier() : super(0) {
    _load();
  }

  Future<void> _load() async {
    final adj = await _storage.getHijriAdjustment();
    state = adj;
  }

  Future<void> setAdjustment(int value) async {
    state = value;
    await _storage.setHijriAdjustment(value);
  }
}

/// Provider utama untuk mendapatkan tanggal Hijriah yang sudah disesuaikan secara reaktif
final hijriDateProvider = Provider<HijriCalendar>((ref) {
  final now = ref.watch(clockProvider.select((s) => s.now));
  final adjustment = ref.watch(hijriAdjustmentProvider);
  final service = ref.watch(hijriServiceProvider);
  
  return service.getHijriDate(now, adjustment);
});
