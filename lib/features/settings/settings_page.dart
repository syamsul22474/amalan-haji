import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/amalan_provider.dart';
import '../../core/providers/clock_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clock = ref.watch(clockProvider);
    final now = clock.now;
    final isSimulationMode = clock.isSimulationMode;
    final formatted = DateFormat('EEE, dd MMM yyyy • HH:mm').format(now);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          if (isSimulationMode) const _SimulationBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _SectionCard(
                  title: 'Simulasi Waktu',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Mode simulasi',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Switch(
                            value: isSimulationMode,
                            activeThumbColor: AppColors.primaryGold,
                            onChanged: (value) {
                              final notifier = ref.read(clockProvider.notifier);
                              if (value) {
                                notifier.setSimulatedTime(now);
                              } else {
                                notifier.setRealTime();
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatted,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: !isSimulationMode
                                  ? null
                                  : () async {
                                      final updated =
                                          await _pickDateTime(context, now);
                                      if (updated == null) return;
                                      ref
                                          .read(clockProvider.notifier)
                                          .setSimulatedTime(updated);
                                    },
                              icon: const Icon(Icons.edit_calendar_rounded),
                              label: const Text('Atur Tanggal/Jam'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _QuickAdjustButton(
                            label: '-1 hari',
                            enabled: isSimulationMode,
                            onTap: () => ref.read(clockProvider.notifier).addDays(-1),
                          ),
                          _QuickAdjustButton(
                            label: '+1 hari',
                            enabled: isSimulationMode,
                            onTap: () => ref.read(clockProvider.notifier).addDays(1),
                          ),
                          _QuickAdjustButton(
                            label: '-1 jam',
                            enabled: isSimulationMode,
                            onTap: () => ref.read(clockProvider.notifier).addHours(-1),
                          ),
                          _QuickAdjustButton(
                            label: '+1 jam',
                            enabled: isSimulationMode,
                            onTap: () => ref.read(clockProvider.notifier).addHours(1),
                          ),
                        ],
                      ),
                      if (isSimulationMode) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => ref.read(clockProvider.notifier).setRealTime(),
                            icon: const Icon(Icons.schedule_rounded),
                            label: const Text('Kembali ke Waktu Nyata'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGold,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  title: 'Data',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reset checklist akan menghapus seluruh progres amalan di perangkat ini.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Reset checklist?'),
                                content: const Text(
                                  'Semua progres akan dihapus dan tidak bisa dikembalikan.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Reset'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed != true) return;
                            await ref.read(amalanProvider.notifier).resetAll();
                          },
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: const Text('Reset Checklist'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _QuickAdjustButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _QuickAdjustButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onTap : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: enabled ? AppColors.textPrimary : AppColors.textSecondary,
        side: BorderSide(
          color: (enabled ? AppColors.primaryGold : AppColors.textSecondary)
              .withValues(alpha: 0.45),
        ),
      ),
      child: Text(label),
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

Future<DateTime?> _pickDateTime(BuildContext context, DateTime current) async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: current,
    firstDate: DateTime(2020),
    lastDate: DateTime(2035),
  );
  if (pickedDate == null) return null;

  if (!context.mounted) return null;
  final pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(current),
  );
  if (pickedTime == null) return null;

  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}
