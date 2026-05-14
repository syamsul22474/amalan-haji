import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/amalan_provider.dart';
import '../../core/providers/current_day_provider.dart';
import 'widgets/amalan_card.dart';
import 'widgets/day_selector.dart';
import 'widgets/waktu_sholat_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDay = ref.watch(currentDayProvider);
    final allAmalan = ref.watch(amalanProvider);

    final amalanHariIni =
        allAmalan.where((a) => a.hariDzulhijjah == currentDay).toList();
    final amalanSelesai = amalanHariIni.where((a) => a.sudahDilakukan).length;
    final progress =
        amalanHariIni.isEmpty ? 0.0 : amalanSelesai / amalanHariIni.length;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Amalan Haji',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          const WaktuSholatBar(),
          const DaySelector(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 6.0,
                  percent: progress,
                  center: Text(
                    "${(progress * 100).toInt()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  progressColor: AppColors.primaryGold,
                  backgroundColor: AppColors.cardBackground,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Progres Hari Ini',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$amalanSelesai dari ${amalanHariIni.length} amalan selesai',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: amalanHariIni.length,
              itemBuilder: (context, index) {
                return AmalanCard(amalan: amalanHariIni[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
