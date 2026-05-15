import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/providers/clock_provider.dart';
import 'core/providers/prayer_time_provider.dart';
import 'core/services/notification_service.dart';
import 'features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Init Hive
  await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: AmalanHajiApp(),
    ),
  );
}

class AmalanHajiApp extends ConsumerStatefulWidget {
  const AmalanHajiApp({super.key});

  @override
  ConsumerState<AmalanHajiApp> createState() => _AmalanHajiAppState();
}

class _AmalanHajiAppState extends ConsumerState<AmalanHajiApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await NotificationService.instance.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      clockProvider.select((s) => s.isSimulationMode),
      (_, next) async {
        if (next) {
          await NotificationService.instance.cancelPrayerReminders();
          return;
        }

        ref.invalidate(prayerTimeProvider);
      },
    );

    ref.listen(
      prayerTimeProvider,
      (_, next) async {
        final clock = ref.read(clockProvider);
        if (clock.isSimulationMode) return;

        final prayerTime = next.valueOrNull;
        if (prayerTime == null) return;

        await NotificationService.instance.schedulePrayerReminders(
          fajr: prayerTime.fajr,
          dhuhr: prayerTime.dhuhr,
          asr: prayerTime.asr,
          maghrib: prayerTime.maghrib,
          isha: prayerTime.isha,
        );
      },
    );

    return MaterialApp(
      title: 'Ceklis Amalan Haji',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
