import 'package:flutter/material.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.notifications_outlined),
              title: Text('Notifikasi Konsultasi'),
              subtitle: Text('Atur pemberitahuan jadwal dan status booking.'),
            ),
            const ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Privasi Data'),
              subtitle: Text('Kelola data pribadi dan riwayat konsultasi.'),
            ),
            const ListTile(
              leading: Icon(Icons.dark_mode_outlined),
              title: Text('Tema Aplikasi'),
              subtitle: Text('Mengikuti sistem perangkat'),
            ),
            const Divider(height: 32),
            // Tombol ini khusus untuk menguji onUnknownRoute sesuai
            // ketentuan pengujian pada modul praktikum. Boleh dihapus
            // setelah tangkapan layar pengujian selesai diambil.
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
