import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StateNotifierProvider<ClockNotifier, DateTime>((ref) {
  return ClockNotifier();
});

class ClockNotifier extends StateNotifier<DateTime> {
  ClockNotifier() : super(DateTime.now());

  bool _isSimulationMode = false;
  Timer? _realTimeTimer;

  // Mode normal: update setiap detik
  void startRealTime() {
    _isSimulationMode = false;
    _realTimeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => state = DateTime.now(),
    );
  }

  // Mode simulasi: set tanggal/jam manual
  void setSimulatedTime(DateTime simulatedTime) {
    _isSimulationMode = true;
    _realTimeTimer?.cancel();
    state = simulatedTime;
  }

  void addHours(int hours) {
    if (_isSimulationMode) state = state.add(Duration(hours: hours));
  }

  void addDays(int days) {
    if (_isSimulationMode) state = state.add(Duration(days: days));
  }

  bool get isSimulationMode => _isSimulationMode;
}
