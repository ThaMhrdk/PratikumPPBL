import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

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
        const Center(child: Text('Warga Kutai Kartanegara')),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Pengaturan'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.pengaturan),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Tentang Aplikasi'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.tentangAplikasi),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Keluar'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.keluar),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
