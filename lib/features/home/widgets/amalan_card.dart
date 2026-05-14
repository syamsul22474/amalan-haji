import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/amalan.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/amalan_provider.dart';

class AmalanCard extends ConsumerWidget {
  final Amalan amalan;

  const AmalanCard({super.key, required this.amalan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // TODO: Navigate to detail
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: amalan.sudahDilakukan,
                activeColor: AppColors.primaryGold,
                onChanged: (value) {
                  ref.read(amalanProvider.notifier).toggleAmalanStatus(amalan);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amalan.nama,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: amalan.sudahDilakukan
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amalan.deskripsi,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
