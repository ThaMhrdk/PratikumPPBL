// lib/pages/halaman_beranda.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorit_model.dart';
import '../models/layanan.dart';
import '../models/pengajuan_model.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: tema.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_city,
                  size: 40,
                  color: tema.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 12),
                Text(
                  'Selamat datang di Nusantara Cerdas Mobile',
                  style: tema.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ajukan layanan perizinan, kesehatan, dan transportasi '
                  'tanpa harus antre di balai kota.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Ringkasan Anda', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        const Row(
          children: [
            Expanded(child: _RingkasanFavorit()),
            SizedBox(width: 12),
            Expanded(child: _RingkasanPengajuan()),
          ],
        ),
        const SizedBox(height: 16),
        Text('Bidang Layanan', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final bidang in daftarBidang)
          Card(
            child: ListTile(
              leading: Icon(ikonBidang[bidang]),
              title: Text(bidang),
              subtitle: Text('${layananBidang(bidang).length} layanan tersedia'),
            ),
          ),
      ],
    );
  }
}

class _RingkasanFavorit extends StatelessWidget {
  const _RingkasanFavorit();

  @override
  Widget build(BuildContext context) {
    final total = context.select<FavoritModel, int>(
      (model) => model.totalFavorit,
    );
    return _KartuRingkasan(
      ikon: Icons.star,
      label: 'Layanan favorit',
      nilai: total,
    );
  }
}

class _RingkasanPengajuan extends StatelessWidget {
  const _RingkasanPengajuan();

  @override
  Widget build(BuildContext context) {
    final total = context.select<PengajuanModel, int>(
      (model) => model.totalPengajuan,
    );
    return _KartuRingkasan(
      ikon: Icons.assignment_turned_in_outlined,
      label: 'Sedang diajukan',
      nilai: total,
    );
  }
}

class _KartuRingkasan extends StatelessWidget {
  const _KartuRingkasan({
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  final IconData ikon;
  final String label;
  final int nilai;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ikon, color: tema.colorScheme.primary),
            const SizedBox(height: 8),
            Text('$nilai', style: tema.textTheme.headlineMedium),
            Text(label),
          ],
        ),
      ),
    );
  }
}
