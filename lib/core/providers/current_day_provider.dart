import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'clock_provider.dart';

final currentDayProvider = StateNotifierProvider<CurrentDayNotifier, int>((ref) {
  final now = ref.read(clockProvider).now;
  final notifier = CurrentDayNotifier(now);

  ref.listen<DateTime>(
    clockProvider.select((s) => DateTime(s.now.year, s.now.month, s.now.day)),
    (_, next) => notifier.followClock(next),
  );

  return notifier;
});

class CurrentDayNotifier extends StateNotifier<int> {
  bool _isManual = false;

  CurrentDayNotifier(DateTime now) : super(8) {
    _setFromClock(now);
  }

  void _setFromClock(DateTime now) {
    final hijri = HijriCalendar.fromDate(now);
    if (hijri.hMonth == 12 && hijri.hDay >= 8 && hijri.hDay <= 13) {
      state = hijri.hDay;
    } else {
      state = 8; // Default to day 8 if not during Hajj
    }
  }

  void followClock(DateTime now) {
    if (_isManual) return;
    _setFromClock(now);
  }

  void setDay(int day) {
    if (day >= 8 && day <= 13) {
      _isManual = true;
      state = day;
    }
  }

  void clearManualOverride() {
    _isManual = false;
  }
}
