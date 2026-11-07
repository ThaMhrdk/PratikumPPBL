import 'package:flutter/material.dart';

class HalamanTentangAplikasi extends StatelessWidget {
  const HalamanTentangAplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Kutkatha')),
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
              'Platform digital layanan psikologis terintegrasi untuk warga Kabupaten Kutai Kartanegara. '
              'Mendukung pilar Smart Living dalam meningkatkan kesehatan mental dan kualitas hidup masyarakat.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 16),
            Text('Versi 1.4.0 (Modul IV - Form, Interaksi, dan Integrasi Pustaka)'),
            Text('Pengembang: Muhammad Anantha Mahardika Ridwan (NIM: 707012400122)'),
            Text('Praktikum Pemrograman Perangkat Bergerak Lanjut (PPBL) 2026'),
          ],
        ),
      ),
    );
  }
}
