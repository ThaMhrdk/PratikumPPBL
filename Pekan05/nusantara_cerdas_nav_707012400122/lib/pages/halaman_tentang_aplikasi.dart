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
            Icon(Icons.location_city, size: 56, color: Colors.teal),
            SizedBox(height: 12),
            Text(
              'Nusantara Cerdas Mobile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi layanan warga Kota Nusantara yang menghadirkan '
              'ringkasan enam pilar smart city, daftar layanan publik, '
              'serta identitas dan riwayat laporan warga dalam satu aplikasi.',
            ),
            SizedBox(height: 16),
            Text('Versi 1.0.0'),
            Text(
              'Dikembangkan untuk Praktikum Pemrograman Perangkat Bergerak Lanjut',
            ),
          ],
        ),
      ),
    );
  }
}
