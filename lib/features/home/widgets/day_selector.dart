import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/current_day_provider.dart';
import '../../../core/providers/amalan_provider.dart';

class DaySelector extends ConsumerWidget {
  const DaySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDay = ref.watch(currentDayProvider);
    final allAmalan = ref.watch(amalanProvider);
    final isNafarAwalTaken =
        allAmalan.any((a) => a.id == 'nafar_awal_12' && a.sudahDilakukan);
    final isNafarAwalFailed = ref.watch(amalanProvider.notifier).isNafarAwalFailed;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ...List.generate(6, (index) {
            final day = 8 + index;

            // Sembunyikan hari ke-13 jika Nafar Awal diambil dan tidak gagal
            if (day == 13 && isNafarAwalTaken && !isNafarAwalFailed) {
              return const SizedBox.shrink();
            }

            final isSelected = day == currentDay;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text('$day Dzul'),
                selected: isSelected,
                selectedColor: AppColors.primaryGold,
                backgroundColor: AppColors.cardBackground,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    ref.read(currentDayProvider.notifier).setDay(day);
                  }
                },
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: const Text('Pulang'),
              selected: currentDay == 99,
              selectedColor: AppColors.primaryGold,
              backgroundColor: AppColors.cardBackground,
              labelStyle: TextStyle(
                color: currentDay == 99 ? Colors.black : AppColors.textPrimary,
                fontWeight: currentDay == 99 ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  ref.read(currentDayProvider.notifier).setDay(99);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
