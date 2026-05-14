import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/amalan.dart';
import '../constants/amalan_data.dart';
import '../services/storage_service.dart';

final amalanProvider = StateNotifierProvider<AmalanNotifier, List<Amalan>>((ref) {
  return AmalanNotifier(StorageService());
});

class AmalanNotifier extends StateNotifier<List<Amalan>> {
  final StorageService _storageService;

  AmalanNotifier(this._storageService) : super(AmalanData.allAmalan) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final updatedList = <Amalan>[];
    for (var amalan in state) {
      final status = await _storageService.getAmalanStatus(
        amalan.hariDzulhijjah,
        amalan.id,
      );
      updatedList.add(amalan.copyWith(sudahDilakukan: status));
    }
    state = updatedList;
  }

  Future<void> refreshFromStorage() async {
    await _loadStatus();
  }

  Future<void> toggleAmalanStatus(Amalan amalan) async {
    await setAmalanStatus(amalan: amalan, status: !amalan.sudahDilakukan);
  }

  Future<void> setAmalanStatus({
    required Amalan amalan,
    required bool status,
  }) async {
    await _storageService.setAmalanStatus(amalan.hariDzulhijjah, amalan.id, status);
    state = state.map((a) {
      return a.id == amalan.id ? a.copyWith(sudahDilakukan: status) : a;
    }).toList();
  }

  Future<void> resetAll() async {
    await _storageService.resetAllChecklist();
    state = AmalanData.allAmalan;
  }
}
