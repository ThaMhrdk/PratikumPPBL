import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanLayanan extends StatelessWidget {
  const HalamanLayanan({super.key});

  static const List<Map<String, String>> _perizinan = [
    {
      'namaLayanan': 'Izin Usaha Mikro (IUMK)',
      'dinas': 'Dinas Penanaman Modal dan PTSP',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Penerbitan izin usaha bagi pelaku UMKM di wilayah Kota Nusantara.',
      'bidang': 'Perizinan',
    },
    {
      'namaLayanan': 'Izin Mendirikan Bangunan (PBG)',
      'dinas': 'Dinas Pekerjaan Umum dan Penataan Ruang',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Persetujuan bangunan gedung hunian maupun komersial warga.',
      'bidang': 'Perizinan',
    },
    {
      'namaLayanan': 'Izin Penyelenggaraan Acara Warga',
      'dinas': 'Satuan Polisi Pamong Praja & Kesbangpol',
      'jamOperasional': 'Senin - Sabtu, 08.00 - 16.00',
      'keterangan': 'Izin keramaian dan pemanfaatan fasilitas ruang publik kota.',
      'bidang': 'Perizinan',
    },
  ];

  static const List<Map<String, String>> _kesehatan = [
    {
      'namaLayanan': 'Pendaftaran Puskesmas Online',
      'dinas': 'Dinas Kesehatan Kota Nusantara',
      'jamOperasional': 'Setiap hari, 07.00 - 20.00',
      'keterangan': 'Antrean terpadu faskes pertama tanpa perlu menunggu lama di lokasi.',
      'bidang': 'Kesehatan',
    },
    {
      'namaLayanan': 'Jadwal Imunisasi & Posyandu Anak',
      'dinas': 'Dinas Kesehatan Kota Nusantara',
      'jamOperasional': 'Senin - Jumat, 08.00 - 14.00',
      'keterangan': 'Layanan pemantauan tumbuh kembang dan vaksinasi balita warga.',
      'bidang': 'Kesehatan',
    },
    {
      'namaLayanan': 'Panggilan Ambulans Cepat Siaga 119',
      'dinas': 'Dinas Kesehatan & RSUD Nusantara',
      'jamOperasional': '24 Jam Non-stop',
      'keterangan': 'Layanan tanggap darurat evakuasi medis darurat di seluruh distrik.',
      'bidang': 'Kesehatan',
    },
  ];

  static const List<Map<String, String>> _transportasi = [
    {
      'namaLayanan': 'Perpanjangan Kartu Bus Kota',
      'dinas': 'Dinas Perhubungan Kota Nusantara',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Kartu langganan smart mobility bus listrik terintegrasi.',
      'bidang': 'Transportasi',
    },
    {
      'namaLayanan': 'Laporan Fasilitas & Halte Rusak',
      'dinas': 'Dinas Perhubungan Kota Nusantara',
      'jamOperasional': 'Setiap hari, 08.00 - 20.00',
      'keterangan': 'Pengaduan kelayakan armada bus, halte, dan jalur sepeda kota.',
      'bidang': 'Transportasi',
    },
    {
      'namaLayanan': 'Izin Trayek Angkutan Lingkungan',
      'dinas': 'Dinas Perhubungan Kota Nusantara',
      'jamOperasional': 'Senin - Jumat, 08.00 - 16.00',
      'keterangan': 'Legalitas operasional feeder shuttle ramah lingkungan pemukiman.',
      'bidang': 'Transportasi',
    },
  ];

  void _bukaFormulir(BuildContext context, Map<String, String> layanan) {
    Navigator.pushNamed(
      context,
      AppRoutes.formulirPengajuan,
      arguments: layanan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.verified_user_outlined), text: 'Perizinan'),
                Tab(icon: Icon(Icons.local_hospital_outlined), text: 'Kesehatan'),
                Tab(icon: Icon(Icons.directions_bus_outlined), text: 'Transportasi'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buatDaftar(context, _perizinan),
                _buatDaftar(context, _kesehatan),
                _buatDaftar(context, _transportasi),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatDaftar(BuildContext context, List<Map<String, String>> daftar) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: daftar.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = daftar[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        _ambilIkon(item['bidang']!),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['namaLayanan']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['dinas']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['keterangan']!,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['jamOperasional']!,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => _bukaFormulir(context, item),
                      icon: const Icon(Icons.edit_note, size: 18),
                      label: const Text('Ajukan'),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _ambilIkon(String bidang) {
    switch (bidang) {
      case 'Perizinan':
        return Icons.business_center_outlined;
      case 'Kesehatan':
        return Icons.medical_services_outlined;
      case 'Transportasi':
        return Icons.electric_bolt_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }
}
