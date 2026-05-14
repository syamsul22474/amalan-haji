import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClockState {
  final DateTime now;
  final bool isSimulationMode;

  const ClockState({
    required this.now,
    required this.isSimulationMode,
  });

  ClockState copyWith({
    DateTime? now,
    bool? isSimulationMode,
  }) {
    return ClockState(
      now: now ?? this.now,
      isSimulationMode: isSimulationMode ?? this.isSimulationMode,
    );
  }
}

final clockProvider = StateNotifierProvider<ClockNotifier, ClockState>((ref) {
  return ClockNotifier();
});

class ClockNotifier extends StateNotifier<ClockState> {
  ClockNotifier()
      : super(
          ClockState(
            now: DateTime.now(),
            isSimulationMode: false,
          ),
        ) {
    _startRealTimeTimer();
  }

  Timer? _realTimeTimer;

  void _startRealTimeTimer() {
    _realTimeTimer?.cancel();
    _realTimeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (state.isSimulationMode) return;
        state = state.copyWith(now: DateTime.now());
      },
    );
  }

  void setRealTime() {
    state = ClockState(now: DateTime.now(), isSimulationMode: false);
    _startRealTimeTimer();
  }

  void setSimulatedTime(DateTime simulatedTime) {
    state = ClockState(now: simulatedTime, isSimulationMode: true);
  }

  void addHours(int hours) {
    if (!state.isSimulationMode) return;
    state = state.copyWith(now: state.now.add(Duration(hours: hours)));
  }

  void addDays(int days) {
    if (!state.isSimulationMode) return;
    state = state.copyWith(now: state.now.add(Duration(days: days)));
  }

  @override
  void dispose() {
    _realTimeTimer?.cancel();
    super.dispose();
  }
}
