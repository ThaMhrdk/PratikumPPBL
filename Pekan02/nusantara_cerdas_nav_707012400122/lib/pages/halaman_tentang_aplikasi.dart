import 'package:flutter/material.dart';

class HalamanTentangAplikasi extends StatelessWidget {
  const HalamanTentangAplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_city, size: 56, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'Nusantara Cerdas Mobile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aplikasi layanan warga Kota Nusantara yang menghadirkan '
              'ringkasan enam pilar smart city, daftar layanan publik, '
              'serta identitas dan riwayat laporan warga dalam satu aplikasi.',
            ),
            const SizedBox(height: 16),
            const Text('Versi 1.0.0'),
            const Text(
              'Dikembangkan untuk Praktikum Pemrograman Perangkat Bergerak Lanjut',
            ),
          ],
        ),
      ),
    );
  }
}
