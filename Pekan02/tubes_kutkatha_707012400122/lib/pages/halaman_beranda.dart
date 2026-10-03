import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    // Tanpa Scaffold, sebab halaman ini tampil di dalam Scaffold
    // milik KerangkaNavigasi.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.self_improvement, size: 40),
                SizedBox(height: 8),
                Text(
                  'Selamat datang di Kutkatha',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Layanan psikologis terintegrasi untuk warga '
                  'Kabupaten Kutai Kartanegara.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Layanan Utama',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _KartuLayanan(
              ikon: Icons.psychology_alt_outlined,
              judul: 'Cari Psikolog',
              // Membuka halaman penuh lewat named route.
              onTap: () => Navigator.pushNamed(context, AppRoutes.psikologList),
            ),
            const _KartuLayanan(
              ikon: Icons.event_available_outlined,
              judul: 'Booking Konsultasi',
            ),
            const _KartuLayanan(
              ikon: Icons.chat_bubble_outline,
              judul: 'Konsultasi Chat',
            ),
            const _KartuLayanan(
              ikon: Icons.forum_outlined,
              judul: 'Forum Komunitas',
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Buka tab Forum untuk melihat diskusi warga, atau tab Profil '
          'untuk mengelola akun dan pengaturan.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _KartuLayanan extends StatelessWidget {
  const _KartuLayanan({required this.ikon, required this.judul, this.onTap});

  final IconData ikon;
  final String judul;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon, size: 30, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                judul,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
