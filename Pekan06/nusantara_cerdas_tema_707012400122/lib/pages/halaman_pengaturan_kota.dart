import 'package:flutter/material.dart';

class HalamanPengaturanKota extends StatelessWidget {
  const HalamanPengaturanKota({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Kota')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.notifications_outlined),
              title: Text('Notifikasi Layanan Warga'),
              subtitle: Text('Atur pemberitahuan status permohonan.'),
            ),
            const ListTile(
              leading: Icon(Icons.language_outlined),
              title: Text('Bahasa Aplikasi'),
              subtitle: Text('Bahasa Indonesia'),
            ),
            const ListTile(
              leading: Icon(Icons.dark_mode_outlined),
              title: Text('Tema Aplikasi'),
              subtitle: Text('Mengikuti sistem perangkat'),
            ),
            const Divider(height: 32),
            // Tombol ini khusus untuk menguji onUnknownRoute sesuai
            // ketentuan pengujian pada modul praktikum (memanggil satu
            // nama route yang tidak terdaftar). Boleh dihapus setelah
            // tangkapan layar pengujian selesai diambil.
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/route-belum-terdaftar'),
              icon: const Icon(Icons.bug_report_outlined),
              label: const Text('Uji Route Tidak Terdaftar'),
            ),
          ],
        ),
      ),
    );
  }
}
