import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'hijri_provider.dart';

final currentDayProvider = StateNotifierProvider<CurrentDayNotifier, int>((ref) {
  final hijri = ref.read(hijriDateProvider);
  final notifier = CurrentDayNotifier(hijri);

  ref.listen<HijriCalendar>(
    hijriDateProvider,
    (_, next) => notifier.followHijri(next),
  );

  return notifier;
});

class CurrentDayNotifier extends StateNotifier<int> {
  bool _isManual = false;

  CurrentDayNotifier(HijriCalendar hijri) : super(8) {
    _setFromHijri(hijri);
  }

  void _setFromHijri(HijriCalendar hijri) {
    if (hijri.hMonth == 12 && hijri.hDay >= 8 && hijri.hDay <= 13) {
      state = hijri.hDay;
    } else {
      state = 8; // Default to day 8 if not during Hajj
    }
  }

  void followHijri(HijriCalendar hijri) {
    if (_isManual) return;
    _setFromHijri(hijri);
  }

  void setDay(int day) {
    if (day >= 8 && day <= 13) {
      _isManual = true;
      state = day;
    }
  }

  void clearManualOverride() {
    _isManual = false;
    // When clearing, we should probably reset to the current hijri date
    // But we don't have access to the provider here easily without ref.
    // However, the next clock tick or adjustment change will trigger followHijri anyway.
  }
}
