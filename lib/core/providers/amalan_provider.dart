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

  Future<void> toggleAmalanStatus(Amalan amalan) async {
    final newStatus = !amalan.sudahDilakukan;
    await _storageService.setAmalanStatus(
      amalan.hariDzulhijjah,
      amalan.id,
      newStatus,
    );
    state = state.map((a) {
      return a.id == amalan.id ? a.copyWith(sudahDilakukan: newStatus) : a;
    }).toList();
  }
}
