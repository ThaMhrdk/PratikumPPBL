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
            const Icon(Icons.self_improvement, size: 56, color: Colors.deepPurple),
            const SizedBox(height: 12),
            const Text(
              'Kutkatha (Kutai Kathana)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Platform digital layanan psikologis terintegrasi untuk warga '
              'Kabupaten Kutai Kartanegara. Aplikasi mobile ini melanjutkan '
              'Tugas PABW dan sudah terhubung dengan API backend Kutkatha.',
            ),
            const SizedBox(height: 16),
            const Text('Versi 1.0.0 (kerangka desain navigasi)'),
            const Text(
              'Dikembangkan untuk Praktikum Modul II - Pemrograman Perangkat '
              'Bergerak Lanjut (Soal 2)',
            ),
          ],
        ),
      ),
    );
  }
}
