import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/amalan_provider.dart';
import '../../core/providers/clock_provider.dart';
import '../../core/providers/current_day_provider.dart';
import '../progress/progress_page.dart';
import '../settings/settings_page.dart';
import 'widgets/amalan_card.dart';
import 'widgets/day_selector.dart';
import 'widgets/waktu_sholat_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ConfettiController _confettiController;
  bool _wasAllDone = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));

    ref.listen(amalanProvider, (_, __) => _checkCompletion());
    ref.listen(currentDayProvider, (_, __) => _checkCompletion());

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkCompletion());
  }

  void _checkCompletion() {
    final currentDay = ref.read(currentDayProvider);
    final allAmalan = ref.read(amalanProvider);

    final amalanHariIni = allAmalan.where((a) => a.hariDzulhijjah == currentDay).toList();
    if (amalanHariIni.isEmpty) {
      _wasAllDone = false;
      return;
    }

    final isAllDone = amalanHariIni.every((a) => a.sudahDilakukan);
    if (isAllDone && !_wasAllDone) {
      _confettiController.play();
    }
    _wasAllDone = isAllDone;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSimulationMode =
        ref.watch(clockProvider.select((s) => s.isSimulationMode));
    final currentDay = ref.watch(currentDayProvider);
    final allAmalan = ref.watch(amalanProvider);

    final amalanHariIni =
        allAmalan.where((a) => a.hariDzulhijjah == currentDay).toList();
    final amalanSelesai = amalanHariIni.where((a) => a.sudahDilakukan).length;
    final progress =
        amalanHariIni.isEmpty ? 0.0 : amalanSelesai / amalanHariIni.length;

    return Stack(
      children: [
        Scaffold(
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
            actions: [
              IconButton(
                tooltip: 'Progress',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProgressPage()),
                  );
                },
                icon: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.primaryGold,
                ),
              ),
              IconButton(
                tooltip: 'Pengaturan',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
                icon: const Icon(Icons.settings_rounded, color: AppColors.primaryGold),
              ),
            ],
          ),
          body: Column(
            children: [
              if (isSimulationMode) const _SimulationBanner(),
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
                child: amalanHariIni.isEmpty
                    ? const EmptyStateWidget(
                        message:
                            'Belum ada amalan untuk hari ini. Coba pilih hari lain.',
                      )
                    : ListView.builder(
                        itemCount: amalanHariIni.length,
                        itemBuilder: (context, index) {
                          return AmalanCard(amalan: amalanHariIni[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.06,
              numberOfParticles: 18,
              gravity: 0.2,
              colors: const [
                AppColors.primaryGold,
                Colors.white,
                Colors.orange,
              ],
            ),
          ),
        ),
      ],
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
