import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/amalan.dart';
import '../../core/providers/amalan_provider.dart';
import '../../core/providers/clock_provider.dart';
import '../../core/providers/hijri_provider.dart';
import '../../core/providers/prayer_time_provider.dart';
import '../../core/models/prayer_time.dart';
import '../../shared/widgets/badge_widget.dart';

class AmalanDetailPage extends ConsumerWidget {
  final String amalanId;

  const AmalanDetailPage({super.key, required this.amalanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSimulationMode =
        ref.watch(clockProvider.select((s) => s.isSimulationMode));
    final amalan = ref
        .watch(amalanProvider)
        .where((a) => a.id == amalanId)
        .cast<Amalan?>()
        .firstOrNull;

    final now = ref.watch(clockProvider.select((s) => s.now));
    final prayerTimeAsync = ref.watch(prayerTimeProvider);

    DateTime? resolveTriggerTime(PrayerTime pt, String? triggerKey) {
      return switch (triggerKey) {
        'fajr' => pt.fajr,
        'syuruq' => pt.syuruq,
        'dhuhr' => pt.dhuhr,
        'asr' => pt.asr,
        'maghrib' => pt.maghrib,
        'isha' => pt.isha,
        _ => null,
      };
    }

    final triggerTime = prayerTimeAsync.maybeWhen(
      data: (pt) => resolveTriggerTime(pt, amalan?.waktuTrigger),
      orElse: () => null,
    );

    final bool isLocked = amalan != null &&
        !amalan.sudahDilakukan &&
        _checkIsLocked(amalan: amalan, currentHijri: ref.watch(hijriDateProvider), now: now, triggerTime: triggerTime);

    if (amalan == null) {
      return const Scaffold(
        body: Center(
          child: Text('Amalan tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: Text(
          amalan.nama,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          if (isSimulationMode) const _SimulationBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BadgeWidget(jenis: amalan.jenis),
                      const SizedBox(width: 10),
                      Text(
                        '${amalan.hariDzulhijjah} Dzulhijjah',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Belum waktunya. Amalan ini dimulai ${_triggerLabel(amalan.waktuTrigger)?.toLowerCase() ?? 'pada waktunya'}.',
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
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
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

                                ref.read(amalanProvider.notifier).setAmalanStatus(
                                      amalan: amalan,
                                      status: value ?? false,
                                    );
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    amalan.deskripsi,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  if ((amalan.waktuKeterangan ?? '').trim().isNotEmpty ||
                      (amalan.waktuTrigger ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 18),
                    const Text(
                      'Waktu',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (amalan.waktuKeterangan ?? '').trim().isNotEmpty
                          ? amalan.waktuKeterangan!
                          : 'Mulai ${_triggerLabel(amalan.waktuTrigger) ?? '-'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (amalan.dalil.trim().isNotEmpty) ...[
                    const SizedBox(height: 18),
                    const Text(
                      'Dalil / Catatan',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      amalan.dalil,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _checkIsLocked({
    required Amalan amalan,
    required HijriCalendar currentHijri,
    required DateTime now,
    required DateTime? triggerTime,
  }) {
    // 1. Cek Bulan
    if (currentHijri.hMonth < 12) return true;
    if (currentHijri.hMonth > 12) return false;

    // 2. Cek Tanggal
    if (currentHijri.hDay < amalan.hariDzulhijjah) return true;
    if (currentHijri.hDay > amalan.hariDzulhijjah) return false;

    // 3. Hari yang sama, baru cek jam
    return triggerTime != null && now.isBefore(triggerTime);
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

String? _triggerLabel(String? triggerKey) {
  return switch (triggerKey) {
    'fajr' => 'Subuh',
    'syuruq' => 'Terbit',
    'dhuhr' => 'Dzuhur',
    'asr' => 'Ashar',
    'maghrib' => 'Maghrib',
    'isha' => 'Isya',
    _ => null,
  };
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
