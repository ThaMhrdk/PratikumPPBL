import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  @override
  Widget build(BuildContext context) {
    // Tanpa Scaffold, sebab halaman ini tampil di dalam Scaffold
    // milik KerangkaNavigasi.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        const SizedBox(height: 12),
        const Center(child: Text('Muhammad Anantha Mahardika Ridwan')),
        const Center(child: Text('NIM 707012400122')),
        const SizedBox(height: 24),
        const Text(
          'Riwayat Laporan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Lihat status permohonan dan laporan yang pernah diajukan.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        // Riwayat Laporan dibuka sebagai halaman penuh melalui named route,
        // sehingga menambah tumpukan route (berbeda dari tiga tujuan utama).
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.riwayatLaporan),
          icon: const Icon(Icons.history),
          label: const Text('Lihat Riwayat Laporan'),
        ),
      ],
    );
  }
}
