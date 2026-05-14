import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/amalan.dart';
import '../../core/providers/amalan_provider.dart';
import '../../core/providers/clock_provider.dart';
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
                        onChanged: (value) {
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
