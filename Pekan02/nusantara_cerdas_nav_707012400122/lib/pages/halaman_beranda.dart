import 'package:flutter/material.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  static const List<_PilarSmartCity> _daftarPilar = [
    _PilarSmartCity(
      'Smart Governance',
      'Layanan pemerintahan yang transparan dan responsif.',
      Icons.account_balance,
    ),
    _PilarSmartCity(
      'Smart Economy',
      'Mendorong iklim usaha dan ekonomi digital warga.',
      Icons.trending_up,
    ),
    _PilarSmartCity(
      'Smart Living',
      'Kualitas hidup warga melalui fasilitas kota yang layak.',
      Icons.holiday_village,
    ),
    _PilarSmartCity(
      'Smart Mobility',
      'Transportasi kota yang efisien dan terintegrasi.',
      Icons.directions_bus,
    ),
    _PilarSmartCity(
      'Smart Environment',
      'Pengelolaan lingkungan dan sumber daya kota.',
      Icons.eco,
    ),
    _PilarSmartCity(
      'Smart People',
      'Partisipasi dan literasi digital warga kota.',
      Icons.groups,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Tanpa Scaffold, sebab halaman ini tampil di dalam Scaffold
    // milik KerangkaNavigasi.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Ringkasan Enam Pilar Smart City',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Nusantara Cerdas Mobile - Layanan Warga Kota Nusantara',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _daftarPilar.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, indeks) {
            final pilar = _daftarPilar[indeks];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pilar.ikon,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pilar.judul,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pilar.deskripsi,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PilarSmartCity {
  const _PilarSmartCity(this.judul, this.deskripsi, this.ikon);
  final String judul;
  final String deskripsi;
  final IconData ikon;
}
