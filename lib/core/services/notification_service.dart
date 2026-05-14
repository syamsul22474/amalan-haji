import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const int _baseId = 6000;

  Future<void> init() async {
    await _ensureInitialized();
  }

  Future<void> schedulePrayerReminders({
    required DateTime fajr,
    required DateTime dhuhr,
    required DateTime asr,
    required DateTime maghrib,
    required DateTime isha,
  }) async {
    await _ensureInitialized();
    await cancelPrayerReminders();

    final items = <({int id, DateTime at, String title, String body})>[
      (
        id: _baseId + 0,
        at: fajr,
        title: 'Pengingat Sholat Subuh',
        body: 'Waktunya sholat Subuh.',
      ),
      (
        id: _baseId + 1,
        at: dhuhr,
        title: 'Pengingat Sholat Dzuhur',
        body: 'Waktunya sholat Dzuhur.',
      ),
      (
        id: _baseId + 2,
        at: asr,
        title: 'Pengingat Sholat Ashar',
        body: 'Waktunya sholat Ashar.',
      ),
      (
        id: _baseId + 3,
        at: maghrib,
        title: 'Pengingat Sholat Maghrib',
        body: 'Waktunya sholat Maghrib.',
      ),
      (
        id: _baseId + 4,
        at: isha,
        title: 'Pengingat Sholat Isya',
        body: 'Waktunya sholat Isya.',
      ),
    ];

    for (final item in items) {
      if (item.at.isBefore(DateTime.now())) continue;
      await _scheduleAt(
        id: item.id,
        at: item.at,
        title: item.title,
        body: item.body,
      );
    }
  }

  Future<void> cancelPrayerReminders() async {
    await _ensureInitialized();
    for (var i = 0; i < 5; i++) {
      await _plugin.cancel(_baseId + i);
    }
  }

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    final localTimezone = await FlutterTimezone.getLocalTimezone();
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(localTimezone));

    const androidInit = AndroidInitializationSettings('ic_launcher');
    const darwinInit = DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
        macOS: darwinInit,
      ),
    );

    await _requestPermissionsIfNeeded();
    _isInitialized = true;
  }

  Future<void> _requestPermissionsIfNeeded() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _scheduleAt({
    required int id,
    required DateTime at,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_reminders',
        'Pengingat Sholat',
        channelDescription: 'Pengingat sholat berdasarkan jadwal waktu sholat.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(at, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
}
