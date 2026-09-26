// lib/pages/halaman_beranda.dart
import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});
  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  String _pesan = 'Belum ada data yang dikirim balik.';
  Future<void> _bukaDetail() async {
    // Perpindahan halaman kini menyebut NAMA route, bukan kelas halaman.
    final hasil = await Navigator.pushNamed(
      context,
      AppRoutes.detail,
      arguments: {
        'judul': 'Detail Mata Kuliah',
        'keterangan': 'Pertemuan ke-2 membahas navigasi dan routing.',
      },
    );
    if (!mounted) return;
    setState(() {
      _pesan = hasil is String ? hasil : 'Halaman ditutup tanpa mengirim data.';
    });
  }

  void _ujiRouteSalah() {
    Navigator.pushNamed(context, '/salah');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 64, color: Colors.indigo),
            const SizedBox(height: 12),
            Text(_pesan, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _bukaDetail,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Buka Detail lewat Named Route'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _ujiRouteSalah,
              child: const Text('Uji Route Salah'),
            ),
          ],
        ),
      ),
    );
  }
}
