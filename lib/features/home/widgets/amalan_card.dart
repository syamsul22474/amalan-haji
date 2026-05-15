import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/models/amalan.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/amalan_provider.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/providers/hijri_provider.dart';
import '../../../core/providers/prayer_time_provider.dart';
import '../../../core/models/prayer_time.dart';
import '../../../shared/widgets/badge_widget.dart';
import '../../detail/amalan_detail_page.dart';

enum _AmalanCardState { belumWaktunya, perluDikerjakan, selesai }

class AmalanCard extends ConsumerWidget {
  final Amalan amalan;

  const AmalanCard({super.key, required this.amalan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(
      clockProvider.select(
        (s) => DateTime(s.now.year, s.now.month, s.now.day, s.now.hour, s.now.minute),
      ),
    );
    final currentHijri = ref.watch(hijriDateProvider);
    final prayerTimeAsync = ref.watch(prayerTimeProvider);

    final allAmalan = ref.watch(amalanProvider);
    final dependency = amalan.dependsOnAmalanId != null
        ? allAmalan.where((a) => a.id == amalan.dependsOnAmalanId).firstOrNull
        : null;
    final bool isDependencyDone = dependency?.sudahDilakukan ?? true;

    final triggerTime = prayerTimeAsync.maybeWhen(
      data: (pt) => _resolveTriggerTime(pt, amalan.waktuTrigger),
      orElse: () => null,
    );

    final cardState = _resolveCardState(
      amalan: amalan,
      currentHijri: currentHijri,
      now: now,
      triggerTime: triggerTime,
      isDependencyDone: isDependencyDone,
    );

    final bool isLocked = cardState == _AmalanCardState.belumWaktunya;

    return Card(
      color: amalan.sudahDilakukan
          ? AppColors.cardBackground.withValues(alpha: 0.5)
          : AppColors.cardBackground,
      margin: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AmalanDetailPage(amalanId: amalan.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: amalan.sudahDilakukan,
                activeColor: AppColors.primaryGold,
                onChanged: (amalan.id == 'tahallul_awal' || amalan.id == 'tahallul_tsani')
                    ? (value) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Amalan ini dicentang otomatis oleh sistem berdasarkan penyelesaian amalan sebelumnya (Jumrah Aqabah, Bercukur, Thawaf & Sa\'i).',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: AppColors.wajibOrange,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    : (value) async {
                        if (isLocked && value == true) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          String message = 'Belum waktunya. Amalan ini dimulai ${_triggerLabel(amalan.waktuTrigger)?.toLowerCase() ?? 'pada waktunya'}.';

                          if (!isDependencyDone && dependency != null) {
                            message = 'Amalan ini terkunci. Anda harus menyelesaikan "${dependency.nama}" terlebih dahulu.';
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                message,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: AppColors.wajibOrange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        if (amalan.sudahDilakukan && value == false) {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.cardBackground,
                              title: const Text(
                                'Batalkan status?',
                                style: TextStyle(color: AppColors.primaryGold),
                              ),
                              content: const Text(
                                'Apakah Anda yakin ingin membatalkan status selesai untuk amalan ini?',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Ya, Batalkan',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                        }

                        if (amalan.id == 'tinggal_mina_12' && value == true) {
                          final maghrib = prayerTimeAsync.maybeWhen(
                            data: (pt) => pt.maghrib,
                            orElse: () => null,
                          );
                          if (maghrib != null && now.isAfter(maghrib)) {
                            ref.read(amalanProvider.notifier).setNafarAwalFailed(true);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Anda meninggalkan Mina setelah Maghrib. Maka Anda wajib mengerjakan amalan di tanggal 13 (Nafar Tsani).',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 5),
                              ),
                            );
                          } else {
                            ref.read(amalanProvider.notifier).setNafarAwalFailed(false);
                          }
                        }

                        if (amalan.id == 'nafar_awal_12' && value == false) {
                          ref.read(amalanProvider.notifier).setNafarAwalFailed(false);
                        }

                        ref.read(amalanProvider.notifier).setAmalanStatus(
                              amalan: amalan,
                              status: value ?? false,
                            );
                      },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            amalan.nama,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: amalan.sudahDilakukan
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _StatusPill(state: cardState),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amalan.deskripsi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        BadgeWidget(jenis: amalan.jenis),
                        if (triggerTime != null)
                          _TimePill(
                            label: _triggerLabel(amalan.waktuTrigger),
                          ),
                        if (isLocked)
                          const Icon(
                            Icons.lock_clock,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: amalan.sudahDilakukan
                    ? const _CheckAnimation(key: ValueKey('done'))
                    : const Icon(
                        Icons.chevron_right,
                        key: ValueKey('go'),
                        color: AppColors.textSecondary,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_AmalanCardState _resolveCardState({
  required Amalan amalan,
  required HijriCalendar currentHijri,
  required DateTime now,
  required DateTime? triggerTime,
  required bool isDependencyDone,
}) {
  if (amalan.sudahDilakukan) return _AmalanCardState.selesai;

  // 0. Cek Dependency
  if (!isDependencyDone) return _AmalanCardState.belumWaktunya;

  // Khusus Ritual Pulang (99) tidak dikunci berdasarkan tanggal
  if (amalan.hariDzulhijjah == 99) return _AmalanCardState.perluDikerjakan;

  // 1. Cek Bulan: Jika sebelum Dzulhijjah (12)
  if (currentHijri.hMonth < 12) return _AmalanCardState.belumWaktunya;
  // Jika tahun depan atau setelah Dzulhijjah (Haji sudah lewat)
  if (currentHijri.hMonth > 12) return _AmalanCardState.perluDikerjakan;

  // 2. Cek Tanggal
  if (currentHijri.hDay < amalan.hariDzulhijjah) return _AmalanCardState.belumWaktunya;
  if (currentHijri.hDay > amalan.hariDzulhijjah) return _AmalanCardState.perluDikerjakan;

  // 3. Hari yang sama, baru cek jam
  if (triggerTime != null && now.isBefore(triggerTime)) {
    return _AmalanCardState.belumWaktunya;
  }

  return _AmalanCardState.perluDikerjakan;
}

DateTime? _resolveTriggerTime(PrayerTime prayerTime, String? triggerKey) {
  return switch (triggerKey) {
    'fajr' => prayerTime.fajr,
    'syuruq' => prayerTime.syuruq,
    'dhuhr' => prayerTime.dhuhr,
    'asr' => prayerTime.asr,
    'maghrib' => prayerTime.maghrib,
    'isha' => prayerTime.isha,
    _ => null,
  };
}

String? _triggerLabel(String? triggerKey) {
  final label = switch (triggerKey) {
    'fajr' => 'Subuh',
    'syuruq' => 'Terbit',
    'dhuhr' => 'Dzuhur',
    'asr' => 'Ashar',
    'maghrib' => 'Maghrib',
    'isha' => 'Isya',
    _ => null,
  };
  if (label == null) return null;
  return 'Mulai $label';
}

class _StatusPill extends StatelessWidget {
  final _AmalanCardState state;

  const _StatusPill({required this.state});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (state) {
      _AmalanCardState.selesai => (
          'SELESAI',
          AppColors.primaryGold.withValues(alpha: 0.18),
          AppColors.primaryGold
        ),
      _AmalanCardState.belumWaktunya => (
          'BELUM',
          AppColors.textSecondary.withValues(alpha: 0.14),
          AppColors.textSecondary
        ),
      _AmalanCardState.perluDikerjakan => (
          'CEK',
          AppColors.cardBackground.withValues(alpha: 0.6),
          AppColors.textPrimary
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 10,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final String? label;

  const _TimePill({required this.label});

  @override
  Widget build(BuildContext context) {
    if (label == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        label!,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _CheckAnimation extends StatefulWidget {
  const _CheckAnimation({super.key});

  @override
  State<_CheckAnimation> createState() => _CheckAnimationState();
}

class _CheckAnimationState extends State<_CheckAnimation> {
  static const _assetPath = 'assets/lotties/check.json';
  late final Future<bool> _assetExistsFuture = _assetExists();

  Future<bool> _assetExists() async {
    try {
      await rootBundle.load(_assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _assetExistsFuture,
      builder: (context, snapshot) {
        final exists = snapshot.data == true;
        if (exists) {
          return SizedBox(
            width: 34,
            height: 34,
            child: Lottie.asset(_assetPath, repeat: false),
          );
        }
        return const Icon(
          Icons.check_circle,
          color: AppColors.primaryGold,
        );
      },
    );
  }
}
