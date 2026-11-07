import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/konsultasi_model.dart';
import '../navigation/app_routes.dart';

class HalamanBeranda extends StatelessWidget {
  final Function(int)? onPilihTab;

  const HalamanBeranda({super.key, this.onPilihTab});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<KonsultasiModel>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Kartu Sambutan Kutkatha
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.self_improvement, size: 36, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kutkatha Mobile',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Layanan Psikologis Warga Kutai Kartanegara',
                            style: TextStyle(fontSize: 12, color: Colors.deepPurple.shade900),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Konsultasi kesehatan mental terpadu bersama psikolog berlisensi. Privasi terjamin, mudah diakses daring maupun tatap muka.',
                  style: TextStyle(fontSize: 13, height: 1.3),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Kartu Status Konsultasi Aktif
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber.shade100,
              child: Icon(Icons.event_available, color: Colors.amber.shade900),
            ),
            title: const Text('Status Sesi Konseling Anda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
            subtitle: Text(
              model.totalAktif > 0
                  ? '${model.totalAktif} sesi aktif menunggu atau sedang berlangsung'
                  : 'Belum ada jadwal sesi aktif. Jadwalkan sekarang.',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Chip(
              label: Text(
                '${model.totalAktif} Aktif',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.deepPurple.shade50,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Grid Menu Layanan Utama
        const Text(
          'Layanan & Fitur Unggulan',
          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.25,
          children: [
            _itemMenu(
              context,
              ikon: Icons.psychology_alt_outlined,
              judul: 'Daftar Psikolog',
              subjudul: 'Pilih tenaga ahli',
              onTap: () => Navigator.pushNamed(context, AppRoutes.psikologList),
            ),
            _itemMenu(
              context,
              ikon: Icons.edit_calendar_outlined,
              judul: 'Booking Konseling',
              subjudul: 'Formulir pendaftaran',
              onTap: () => Navigator.pushNamed(context, AppRoutes.formulirKonseling),
            ),
            _itemMenu(
              context,
              ikon: Icons.chat_bubble_outline,
              judul: 'Chat Psikolog',
              subjudul: 'Konseling online',
              onTap: () {
                if (onPilihTab != null) onPilihTab!(2);
              },
            ),
            _itemMenu(
              context,
              ikon: Icons.map_outlined,
              judul: 'Peta Klinik Mitra',
              subjudul: 'Lokasi faskes Kukar',
              onTap: () {
                if (onPilihTab != null) onPilihTab!(3);
              },
            ),
            _itemMenu(
              context,
              ikon: Icons.bar_chart_outlined,
              judul: 'Statistik Tren',
              subjudul: 'Pemantauan isu',
              onTap: () {
                if (onPilihTab != null) onPilihTab!(4);
              },
            ),
            _itemMenu(
              context,
              ikon: Icons.history_edu_outlined,
              judul: 'Riwayat Sesi',
              subjudul: 'Jadwal & status',
              onTap: () {
                if (onPilihTab != null) onPilihTab!(1);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _itemMenu(
    BuildContext context, {
    required IconData ikon,
    required String judul,
    required String subjudul,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon, size: 28, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 6),
              Text(
                judul,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                subjudul,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10.5, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
