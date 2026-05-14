import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'clock_provider.dart';

final currentDayProvider = StateNotifierProvider<CurrentDayNotifier, int>((ref) {
  final now = ref.watch(clockProvider);
  return CurrentDayNotifier(now);
});

class CurrentDayNotifier extends StateNotifier<int> {
  CurrentDayNotifier(DateTime now) : super(8) {
    _initDay(now);
  }

  void _initDay(DateTime now) {
    final hijri = HijriCalendar.fromDate(now);
    if (hijri.hMonth == 12 && hijri.hDay >= 8 && hijri.hDay <= 13) {
      state = hijri.hDay;
    } else {
      state = 8; // Default to day 8 if not during Hajj
    }
  }

  void setDay(int day) {
    if (day >= 8 && day <= 13) {
      state = day;
    }
  }
}
