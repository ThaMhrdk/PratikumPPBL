import 'package:flutter/material.dart';

/// KartuLayanan adalah Custom Reusable Widget yang membungkus informasi
/// layanan publik (nama, instansi pengelola, bidang, dan tombol aksi).
///
/// Seluruh warna, tipografi, dan gaya permukaan diambil langsung dari
/// Theme.of(context), sehingga kartu ini secara otomatis beradaptasi
/// saat aplikasi beralih antara Mode Terang dan Mode Gelap.
class KartuLayanan extends StatelessWidget {
  final Map<String, String> layanan;
  final VoidCallback? onTap;
  final Widget? trailing;
  final VoidCallback? onAjukan;

  const KartuLayanan({
    super.key,
    required this.layanan,
    this.onTap,
    this.trailing,
    this.onAjukan,
  });

  IconData _getIconBidang(String? bidang) {
    switch (bidang?.toLowerCase()) {
      case 'kesehatan':
        return Icons.local_hospital;
      case 'transportasi':
        return Icons.directions_bus;
      case 'perizinan':
      default:
        return Icons.assignment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nama = layanan['namaLayanan'] ?? 'Layanan';
    final dinas = layanan['dinas'] ?? '-';
    final bidang = layanan['bidang'] ?? 'Umum';
    final jam = layanan['jamOperasional'];

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconBidang(bidang),
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dinas,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              if (jam != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 15,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        jam,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
