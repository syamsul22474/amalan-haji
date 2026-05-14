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
}
