// lib/pages/halaman_info.dart
import 'package:flutter/material.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Nusantara Cerdas Mobile adalah purwarupa aplikasi layanan warga '
          'smart city. Warga dapat menelusuri layanan, menandai favorit, dan '
          'mengajukan beberapa permohonan sekaligus.',
        ),
      ),
    );
  }
}

class HalamanBantuan extends StatelessWidget {
  const HalamanBantuan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '1. Buka tujuan Layanan dan pilih bidang yang diinginkan.\n'
          '2. Ketuk bintang untuk menandai layanan sebagai favorit.\n'
          '3. Ketuk kartu layanan, lalu tekan Ajukan Permohonan.\n'
          '4. Buka tujuan Warga untuk melihat favorit dan mengirim pengajuan.',
        ),
      ),
    );
  }
}
