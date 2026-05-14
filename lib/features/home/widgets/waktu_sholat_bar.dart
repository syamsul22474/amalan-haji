import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/prayer_time_provider.dart';
import '../../../shared/widgets/loading_shimmer.dart';

class WaktuSholatBar extends ConsumerWidget {
  const WaktuSholatBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimeAsync = ref.watch(prayerTimeProvider);

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: prayerTimeAsync.when(
        data: (prayerTime) {
          final times = [
            {'name': 'Subuh', 'time': prayerTime.fajr},
            {'name': 'Terbit', 'time': prayerTime.syuruq},
            {'name': 'Dzuhur', 'time': prayerTime.dhuhr},
            {'name': 'Ashar', 'time': prayerTime.asr},
            {'name': 'Maghrib', 'time': prayerTime.maghrib},
            {'name': 'Isya', 'time': prayerTime.isha},
          ];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: times.length,
            itemBuilder: (context, index) {
              final item = times[index];
              final timeStr = DateFormat('HH:mm').format(item['time'] as DateTime);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['name'] as String,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        color: AppColors.primaryGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const LoadingShimmer(),
        error: (err, stack) => const Center(child: Text('Gagal memuat jadwal')),
      ),
    );
  }
}
