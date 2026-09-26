import 'package:flutter/material.dart';
import 'kepala_kota.dart';
import 'kartu_pilar.dart';
import 'panel_laporan.dart';

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        title: const Text('Nusantara Cerdas'),
        centerTitle: true,
      ),
      // SingleChildScrollView agar tampilan tetap dapat digulir pada
      // layar perangkat berukuran kecil.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const KepalaKota(
              namaKota: 'Kota Nusantara',
              semboyanKota: 'Bersama Membangun Kota Cerdas',
            ),
            const SizedBox(height: 20),
            const Text(
              'Enam Pilar Smart City',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: KartuPilar(
                    namaPilar: 'Smart Governance',
                    ikon: Icons.account_balance,
                    deskripsi:
                        'Layanan pemerintahan yang transparan dan responsif.',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: KartuPilar(
                    namaPilar: 'Smart Economy',
                    ikon: Icons.trending_up,
                    deskripsi:
                        'Mendorong iklim usaha dan ekonomi digital warga.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: KartuPilar(
                    namaPilar: 'Smart Living',
                    ikon: Icons.holiday_village,
                    deskripsi:
                        'Kualitas hidup warga melalui fasilitas kota yang layak.',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: KartuPilar(
                    namaPilar: 'Smart Mobility',
                    ikon: Icons.directions_bus,
                    deskripsi:
                        'Transportasi kota yang efisien dan terintegrasi.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: KartuPilar(
                    namaPilar: 'Smart Environment',
                    ikon: Icons.eco,
                    deskripsi: 'Pengelolaan lingkungan dan sumber daya kota.',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: KartuPilar(
                    namaPilar: 'Smart People',
                    ikon: Icons.groups,
                    deskripsi: 'Partisipasi dan literasi digital warga kota.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Laporan Warga',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const PanelLaporanWarga(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
