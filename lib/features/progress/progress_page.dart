import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/amalan_provider.dart';
import '../../core/providers/clock_provider.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSimulationMode =
        ref.watch(clockProvider.select((s) => s.isSimulationMode));
    final allAmalan = ref.watch(amalanProvider);

    final total = allAmalan.length;
    final totalDone = allAmalan.where((a) => a.sudahDilakukan).length;
    final totalProgress = total == 0 ? 0.0 : totalDone / total;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: const Text(
          'Progress',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          if (isSimulationMode) const _SimulationBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _OverallCard(
                  totalProgress: totalProgress,
                  totalDone: totalDone,
                  total: total,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Per Hari (8–13 Dzulhijjah)',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(6, (index) {
                  final day = 8 + index;
                  final list = allAmalan.where((a) => a.hariDzulhijjah == day).toList()
                    ..sort((a, b) => a.urutan.compareTo(b.urutan));
                  final done = list.where((a) => a.sudahDilakukan).length;
                  final percent = list.isEmpty ? 0.0 : done / list.length;
                  return _DayProgressCard(
                    day: day,
                    done: done,
                    total: list.length,
                    percent: percent,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  final double totalProgress;
  final int totalDone;
  final int total;

  const _OverallCard({
    required this.totalProgress,
    required this.totalDone,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 34.0,
            lineWidth: 7.0,
            percent: totalProgress.clamp(0.0, 1.0),
            center: Text(
              "${(totalProgress * 100).toInt()}%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            progressColor: AppColors.primaryGold,
            backgroundColor: AppColors.darkBackground,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Progress',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalDone dari $total amalan selesai',
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
    );
  }
}

class _DayProgressCard extends StatelessWidget {
  final int day;
  final int done;
  final int total;
  final double percent;

  const _DayProgressCard({
    required this.day,
    required this.done,
    required this.total,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$day Dzulhijjah',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '$done/$total',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 10,
            percent: percent.clamp(0.0, 1.0),
            progressColor: AppColors.primaryGold,
            backgroundColor: AppColors.darkBackground,
            barRadius: const Radius.circular(999),
          ),
        ],
      ),
    );
  }
}

class _SimulationBanner extends StatelessWidget {
  const _SimulationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.orange.withValues(alpha: 0.22),
      child: const Text(
        'Mode simulasi aktif — waktu aplikasi tidak sama dengan waktu nyata.',
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
