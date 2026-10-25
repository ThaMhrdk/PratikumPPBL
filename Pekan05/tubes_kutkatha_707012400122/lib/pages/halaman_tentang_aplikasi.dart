import 'package:flutter/material.dart';

class HalamanTentangAplikasi extends StatelessWidget {
  const HalamanTentangAplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.self_improvement, size: 56, color: Colors.deepPurple),
            SizedBox(height: 12),
            Text(
              'Kutkatha (Kutai Kathana)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Platform digital layanan psikologis terintegrasi untuk warga '
              'Kabupaten Kutai Kartanegara. Aplikasi mobile ini melanjutkan '
              'Tugas PABW dan sudah terhubung dengan API backend Kutkatha.',
            ),
            SizedBox(height: 16),
            Text('Versi 1.0.0 (kerangka desain navigasi)'),
            Text(
              'Dikembangkan untuk Praktikum Modul II - Pemrograman Perangkat '
              'Bergerak Lanjut (Soal 2)',
            ),
          ],
        ),
      ),
    );
  }
}
