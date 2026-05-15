import 'package:flutter/material.dart';
import '../../core/models/amalan.dart';
import '../../core/constants/app_colors.dart';

class BadgeWidget extends StatelessWidget {
  final JenisAmalan jenis;

  const BadgeWidget({super.key, required this.jenis});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (jenis) {
      JenisAmalan.rukun => ('RUKUN', AppColors.rukunRed),
      JenisAmalan.wajib => ('WAJIB', AppColors.wajibOrange),
      JenisAmalan.sunnah => ('SUNNAH', AppColors.sunnahGreen),
      JenisAmalan.pilihan => ('PILIHAN', Colors.blue),
      JenisAmalan.status => ('STATUS', Colors.teal),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
