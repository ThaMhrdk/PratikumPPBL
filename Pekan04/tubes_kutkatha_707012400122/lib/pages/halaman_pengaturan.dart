import 'package:flutter/material.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifikasi Jadwal Sesi'),
            subtitle: Text('Pengingat jadwal konseling 1 jam sebelumnya'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Privasi & Keamanan'),
            subtitle: Text('Enkripsi data sesi dan riwayat konseling warga'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text('Tema Tampilan'),
            subtitle: Text('Mengikuti pengaturan sistem perangkat'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text('Bahasa'),
            subtitle: Text('Bahasa Indonesia'),
          ),
        ],
      ),
    );
  }
}
