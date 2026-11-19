import 'package:flutter/material.dart';
import 'primary_button.dart';

class PantauanSummaryBar extends StatelessWidget {
  final int totalSensor;
  final int totalNilai;
  final VoidCallback onKosongkan;
  final VoidCallback onSimpan;

  const PantauanSummaryBar({
    super.key,
    required this.totalSensor,
    required this.totalNilai,
    required this.onKosongkan,
    required this.onSimpan,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$totalSensor sensor • Total: $totalNilai',
            style: theme.textTheme.titleMedium,
          ),
          Row(
            children: [
              PrimaryButton(
                label: 'Kosongkan',
                icon: Icons.delete_outline,
                onPressed: onKosongkan,
              ),
              const SizedBox(width: 8),
              PrimaryButton(
                label: 'Simpan',
                icon: Icons.check_circle_outline,
                onPressed: onSimpan,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
