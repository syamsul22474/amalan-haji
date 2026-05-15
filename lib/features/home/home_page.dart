import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/amalan.dart';
import '../../core/providers/amalan_provider.dart';
import '../../core/providers/clock_provider.dart';
import '../../core/providers/current_day_provider.dart';
import '../progress/progress_page.dart';
import '../settings/settings_page.dart';
import 'widgets/amalan_card.dart';
import 'widgets/date_header.dart';
import 'widgets/day_selector.dart';
import 'widgets/ongoing_amalan_sheet.dart';
import 'widgets/progress_summary_card.dart';
import 'widgets/today_progress_linear_card.dart';
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

  void _showRemainingAmalan(String title, List<Amalan> amalanList) {
    final remaining = amalanList.where((a) => !a.sudahDilakukan).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryGold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              remaining.isEmpty
                  ? 'Semua amalan kategori ini telah selesai dikerjakan. Alhamdulillah!'
                  : 'Daftar amalan yang belum dikerjakan:',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            if (remaining.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: remaining.length,
                  itemBuilder: (context, index) {
                    final item = remaining[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGold,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nama,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  item.hariDzulhijjah == 99
                                      ? 'Ritual Pulang'
                                      : 'Hari ke-${item.hariDzulhijjah - 7} (${item.hariDzulhijjah} Dzulhijjah)',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(amalanProvider, (_, __) => _checkCompletion());
    ref.listen(currentDayProvider, (_, __) => _checkCompletion());

    final isSimulationMode =
        ref.watch(clockProvider.select((s) => s.isSimulationMode));
    final currentDay = ref.watch(currentDayProvider);
    final allAmalan = ref.watch(amalanProvider);

    final isNafarAwalTaken = allAmalan.any((a) => a.id == 'nafar_awal_12' && a.sudahDilakukan);

    final amalanHariIni = allAmalan.where((a) {
      if (a.hariDzulhijjah != currentDay) return false;

      // Logic Nafar Awal di Tanggal 12
      if (currentDay == 12) {
        if (a.id == 'tinggal_mina_12') {
          if (!isNafarAwalTaken) return false;
        }
        // Jika Nafar Awal diambil, Mabit Mina malam 13 (id: mabit_mina_12) dihilangkan
        if (a.id == 'mabit_mina_12' && isNafarAwalTaken) return false;
      }

      return true;
    }).toList();

    final amalanSelesai = amalanHariIni.where((a) => a.sudahDilakukan).length;
    final progress =
        amalanHariIni.isEmpty ? 0.0 : amalanSelesai / amalanHariIni.length;

    final rukunAmalan = allAmalan.where((a) => a.jenis == JenisAmalan.rukun).toList();
    final rukunSelesai = rukunAmalan.where((a) => a.sudahDilakukan).length;
    final rukunProgress = rukunAmalan.isEmpty ? 0.0 : rukunSelesai / rukunAmalan.length;

    final wajibAmalan = allAmalan.where((a) => a.jenis == JenisAmalan.wajib).toList();
    final wajibSelesai = wajibAmalan.where((a) => a.sudahDilakukan).length;
    final wajibProgress = wajibAmalan.isEmpty ? 0.0 : wajibSelesai / wajibAmalan.length;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            title: const Text(
              'Ceklis Amalan Haji',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.darkBackground,
            elevation: 0,
            actions: [
              IconButton(
                tooltip: 'Amalan Berlangsung',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const OngoingAmalanSheet(),
                  );
                },
                icon: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.primaryGold,
                ),
              ),
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
              const DateHeader(),
              const WaktuSholatBar(),
              const DaySelector(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ProgressSummaryCard(
                            title: 'Total Rukun',
                            subtitle: '$rukunSelesai dari ${rukunAmalan.length} selesai',
                            progress: rukunProgress,
                            progressColor: AppColors.rukunRed,
                            onTap: () => _showRemainingAmalan('Daftar Rukun Haji', rukunAmalan),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ProgressSummaryCard(
                            title: 'Total Wajib',
                            subtitle: '$wajibSelesai dari ${wajibAmalan.length} selesai',
                            progress: wajibProgress,
                            progressColor: AppColors.wajibOrange,
                            onTap: () => _showRemainingAmalan('Daftar Wajib Haji', wajibAmalan),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TodayProgressLinearCard(
                      title: 'Progres Hari Ini',
                      subtitle: '$amalanSelesai dari ${amalanHariIni.length} selesai',
                      progress: progress,
                      progressColor: AppColors.primaryGold,
                      onTap: () => _showRemainingAmalan('Belum Selesai Hari Ini', amalanHariIni),
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
