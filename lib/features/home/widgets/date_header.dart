import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/providers/hijri_provider.dart';

class DateHeader extends ConsumerWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider.select((s) => s.now));
    final hijriDate = ref.watch(hijriDateProvider);
    
    // Hijri Date
    final hijriMonthName = _getIndonesianHijriMonth(hijriDate.hMonth);
    final hijriStr = "${hijriDate.hDay} $hijriMonthName ${hijriDate.hYear} H";

    // Gregorian Date & Time
    final day = now.day;
    final monthName = _getIndonesianMonth(now.month);
    final year = now.year;
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final gregorianStr = "$day $monthName $year • $hour:$minute WIB";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hijriStr,
            style: GoogleFonts.amiri(
              color: AppColors.primaryGold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            gregorianStr,
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getIndonesianMonth(int month) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month];
  }

  String _getIndonesianHijriMonth(int month) {
    const months = [
      '', 'Muharram', 'Safar', 'Rabiul Awal', 'Rabiul Akhir', 'Jumadil Awal', 'Jumadil Akhir',
      'Rajab', 'Syaban', 'Ramadhan', 'Syawal', 'Dzulkaidah', 'Dzulhijjah'
    ];
    return months[month];
  }
}
