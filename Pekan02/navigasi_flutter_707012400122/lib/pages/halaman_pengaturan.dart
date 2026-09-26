// lib/pages/halaman_pengaturan.dart (versi sederhana)
import 'package:flutter/material.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: const Center(child: Text('Halaman Pengaturan')),
    );
  }
}
