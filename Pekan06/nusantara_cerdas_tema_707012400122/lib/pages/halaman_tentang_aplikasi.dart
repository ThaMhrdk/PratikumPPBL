import 'package:flutter/material.dart';

class HalamanTentangAplikasi extends StatelessWidget {
  const HalamanTentangAplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_city,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Nusantara Cerdas Mobile',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aplikasi layanan warga Kota Nusantara yang menghadirkan '
              'ringkasan enam pilar smart city, daftar layanan publik, '
              'serta identitas dan riwayat laporan warga dalam satu aplikasi.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Versi 1.0.0 (Modul 6 Pembuatan Tema & Custom Widget)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Dikembangkan untuk Praktikum Pemrograman Perangkat Bergerak Lanjut',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
