import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/amalan.dart';
import '../../../core/providers/amalan_provider.dart';
import '../../../core/providers/hijri_provider.dart';
import '../../../shared/widgets/badge_widget.dart';

class OngoingAmalanSheet extends ConsumerWidget {
  const OngoingAmalanSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentHijri = ref.watch(hijriDateProvider);
    final allAmalan = ref.watch(amalanProvider);

    // Filter amalan yang sedang berlangsung (Ongoing)
    final List<Amalan> ongoingAmalan = allAmalan.where((a) {
      // Hanya amalan yang punya batas akhir (tanggal atau amalan lain)
      if (a.hariDzulhijjahEnd == null && a.endConditionAmalanId == null) return false;
      
      // Harus sudah masuk/melewati hari mulai
      final isStarted = currentHijri.hMonth == 12 && currentHijri.hDay >= a.hariDzulhijjah;
      if (!isStarted) return false;

      // Cek apakah amalan syarat selesainya sudah dilakukan
      if (a.endConditionAmalanId != null) {
        final dependencyDone = allAmalan.any((target) => target.id == a.endConditionAmalanId && target.sudahDilakukan);
        if (dependencyDone) return false;
      }

      // Jika hanya berdasarkan tanggal dan sudah lewat harinya
      if (a.endConditionAmalanId == null && a.hariDzulhijjahEnd != null) {
        if (currentHijri.hDay > a.hariDzulhijjahEnd!) return false;
      }

      // Catatan: amalan tetap muncul di sini meskipun a.sudahDilakukan = true, 
      // agar jamaah ingat bahwa amalan ini berkelanjutan sampai batas akhirnya.
      // Ia baru hilang jika dependencyDone = true atau lewat tanggalnya.

      return true;
    }).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
          const Text(
            'Amalan Berlangsung',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Amalan yang aktif selama beberapa hari pelaksanaan haji.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),
          if (ongoingAmalan.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'Tidak ada amalan berdurasi yang aktif hari ini.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ongoingAmalan.length,
                itemBuilder: (context, index) {
                  final amalan = ongoingAmalan[index];
                  final sisaHari = amalan.hariDzulhijjahEnd! - currentHijri.hDay;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: amalan.sudahDilakukan 
                            ? AppColors.primaryGold.withValues(alpha: 0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  BadgeWidget(jenis: amalan.jenis),
                                  const SizedBox(width: 10),
                                  Text(
                                    sisaHari == 0 
                                        ? 'Hari Terakhir' 
                                        : 'Sisa $sisaHari hari',
                                    style: TextStyle(
                                      color: sisaHari == 0 ? Colors.orange : AppColors.primaryGold,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                amalan.nama,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: amalan.sudahDilakukan ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                amalan.deskripsi,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: amalan.sudahDilakukan,
                          activeColor: AppColors.primaryGold,
                          onChanged: (value) async {
                            if (amalan.sudahDilakukan && value == false) {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColors.cardBackground,
                                  title: const Text('Batalkan status?', style: TextStyle(color: AppColors.primaryGold)),
                                  content: const Text('Apakah Anda yakin ingin membatalkan status selesai untuk amalan ini?', style: TextStyle(color: AppColors.textPrimary)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.red)),
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
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
