import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const _boxName = 'amalan_checklist';

  Future<void> init() async {
    // Hive initialization is typically done in main.dart
  }

  Future<void> setAmalanStatus(int hari, String amalanId, bool status) async {
    final box = await Hive.openBox(_boxName);
    await box.put('hari_${hari}_$amalanId', status);
  }

  Future<bool> getAmalanStatus(int hari, String amalanId) async {
    final box = await Hive.openBox(_boxName);
    return box.get('hari_${hari}_$amalanId', defaultValue: false);
  }

  Future<void> resetAllChecklist() async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
  }

  // Hijri Adjustment
  static const _settingsBox = 'app_settings';
  static const _hijriAdjKey = 'hijri_adjustment';

  Future<void> setHijriAdjustment(int offset) async {
    final box = await Hive.openBox(_settingsBox);
    await box.put(_hijriAdjKey, offset);
  }

  Future<int> getHijriAdjustment() async {
    final box = await Hive.openBox(_settingsBox);
    return box.get(_hijriAdjKey, defaultValue: 0);
  }

  // Nafar Awal Status
  static const _nafarFailedKey = 'nafar_awal_failed';

  Future<void> setNafarAwalFailed(bool failed) async {
    final box = await Hive.openBox(_settingsBox);
    await box.put(_nafarFailedKey, failed);
  }

  Future<bool> getNafarAwalFailed() async {
    final box = await Hive.openBox(_settingsBox);
    return box.get(_nafarFailedKey, defaultValue: false);
  }

  // Prayer Times Cache
  static const _prayerTimeBox = 'prayer_times_cache';

  Future<void> setCachedPrayerTime(DateTime date, Map<dynamic, dynamic> timings) async {
    final box = await Hive.openBox(_prayerTimeBox);
    final key = 'pt_${date.year}_${date.month}_${date.day}';
    await box.put(key, timings);
  }

  Future<Map<String, dynamic>?> getCachedPrayerTime(DateTime date) async {
    final box = await Hive.openBox(_prayerTimeBox);
    final key = 'pt_${date.year}_${date.month}_${date.day}';
    final data = box.get(key);
    if (data != null) {
      return Map<String, dynamic>.from(data as Map);
    }
    return null;
  }
}
