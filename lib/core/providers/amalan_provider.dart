import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/amalan.dart';
import '../constants/amalan_data.dart';
import '../services/storage_service.dart';

final amalanProvider = StateNotifierProvider<AmalanNotifier, List<Amalan>>((ref) {
  return AmalanNotifier(StorageService());
});

class AmalanNotifier extends StateNotifier<List<Amalan>> {
  final StorageService _storageService;
  bool _isNafarAwalFailed = false;

  AmalanNotifier(this._storageService) : super(AmalanData.allAmalan) {
    _loadStatus();
  }

  bool get isNafarAwalFailed => _isNafarAwalFailed;

  Future<void> setNafarAwalFailed(bool failed) async {
    _isNafarAwalFailed = failed;
    await _storageService.setNafarAwalFailed(failed);
    // Trigger state update to notify listeners
    state = [...state];
  }

  Future<void> _loadStatus() async {
    _isNafarAwalFailed = await _storageService.getNafarAwalFailed();
    final updatedList = <Amalan>[];
    for (var amalan in state) {
      final status = await _storageService.getAmalanStatus(
        amalan.hariDzulhijjah,
        amalan.id,
      );
      updatedList.add(amalan.copyWith(sudahDilakukan: status));
    }
    state = updatedList;
    await _checkTahallulConditions();
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
    // Proteksi: Jika amalan memiliki dependensi dan dependensi tersebut belum selesai,
    // jangan izinkan untuk mencentang amalan ini.
    if (status && amalan.dependsOnAmalanId != null) {
      final dependency =
          state.where((a) => a.id == amalan.dependsOnAmalanId).firstOrNull;
      if (dependency != null && !dependency.sudahDilakukan) {
        return;
      }
    }

    await _storageService.setAmalanStatus(
        amalan.hariDzulhijjah, amalan.id, status);
    state = state.map((a) {
      return a.id == amalan.id ? a.copyWith(sudahDilakukan: status) : a;
    }).toList();

    if (['aqabah_10', 'cukur_10', 'thawaf_ifadhah', 'sai'].contains(amalan.id)) {
      await _checkTahallulConditions();
    }
  }

  Future<void> _checkTahallulConditions() async {
    final aqabah = state.where((a) => a.id == 'aqabah_10').firstOrNull?.sudahDilakukan ?? false;
    final cukur = state.where((a) => a.id == 'cukur_10').firstOrNull?.sudahDilakukan ?? false;
    final thawaf = state.where((a) => a.id == 'thawaf_ifadhah').firstOrNull?.sudahDilakukan ?? false;
    final sai = state.where((a) => a.id == 'sai').firstOrNull?.sudahDilakukan ?? false;

    final thawafSaiDone = thawaf && sai;
    
    int completedCount = 0;
    if (aqabah) completedCount++;
    if (cukur) completedCount++;
    if (thawafSaiDone) completedCount++;

    final shouldAwal = completedCount >= 2;
    final shouldTsani = completedCount == 3;

    final awal = state.where((a) => a.id == 'tahallul_awal').firstOrNull;
    if (awal != null && awal.sudahDilakukan != shouldAwal) {
      await _storageService.setAmalanStatus(awal.hariDzulhijjah, awal.id, shouldAwal);
      state = state.map((a) => a.id == awal.id ? a.copyWith(sudahDilakukan: shouldAwal) : a).toList();
    }

    final tsani = state.where((a) => a.id == 'tahallul_tsani').firstOrNull;
    if (tsani != null && tsani.sudahDilakukan != shouldTsani) {
      await _storageService.setAmalanStatus(tsani.hariDzulhijjah, tsani.id, shouldTsani);
      state = state.map((a) => a.id == tsani.id ? a.copyWith(sudahDilakukan: shouldTsani) : a).toList();
    }
  }

  Future<void> resetAll() async {
    await _storageService.resetAllChecklist();
    state = AmalanData.allAmalan;
  }
}
