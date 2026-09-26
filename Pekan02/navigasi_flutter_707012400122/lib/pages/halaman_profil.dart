// lib/pages/halaman_profil.dart (tulis ulang seluruh berkas)
import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});
  @override
  Widget build(BuildContext context) {
    // Tanpa Scaffold, sebab halaman ini tampil di dalam kerangka navigasi.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        const SizedBox(height: 16),
        const Center(child: Text('Muhammad Anantha Mahardika Ridwan')),
        const Center(child: Text('707012400122')),
        const SizedBox(height: 24),
        // Tombol inilah jalan masuk ke halaman catatan.
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.catatan),
          icon: const Icon(Icons.note_alt_outlined),
          label: const Text('Buka Halaman Catatan'),
        ),
      ],
    );
  }
}
