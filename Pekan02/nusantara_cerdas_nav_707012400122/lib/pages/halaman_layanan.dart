import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanLayanan extends StatefulWidget {
  const HalamanLayanan({super.key});

  @override
  State<HalamanLayanan> createState() => _HalamanLayananState();
}

class _HalamanLayananState extends State<HalamanLayanan> {
  static const List<Map<String, String>> _perizinan = [
    {
      'namaLayanan': 'Izin Usaha Mikro',
      'dinas': 'Dinas Penanaman Modal dan PTSP',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Pengajuan izin usaha untuk pelaku UMKM di Kota Nusantara.',
    },
    {
      'namaLayanan': 'Izin Mendirikan Bangunan',
      'dinas': 'Dinas Pekerjaan Umum dan Tata Ruang',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Perizinan pendirian bangunan baru maupun renovasi.',
    },
    {
      'namaLayanan': 'Izin Keramaian',
      'dinas': 'Satuan Polisi Pamong Praja',
      'jamOperasional': 'Senin - Sabtu, 08.00 - 16.00',
      'keterangan': 'Izin penyelenggaraan kegiatan atau acara warga.',
    },
  ];

  static const List<Map<String, String>> _kesehatan = [
    {
      'namaLayanan': 'Pendaftaran Puskesmas Online',
      'dinas': 'Dinas Kesehatan Kota Nusantara',
      'jamOperasional': 'Setiap hari, 07.00 - 20.00',
      'keterangan':
          'Pendaftaran antrean puskesmas terdekat tanpa perlu mengantre di lokasi.',
    },
    {
      'namaLayanan': 'Jadwal Imunisasi Anak',
      'dinas': 'Dinas Kesehatan Kota Nusantara',
      'jamOperasional': 'Senin - Jumat, 08.00 - 14.00',
      'keterangan': 'Informasi jadwal dan lokasi imunisasi anak di posyandu.',
    },
    {
      'namaLayanan': 'Layanan Ambulans Darurat',
      'dinas': 'Dinas Kesehatan Kota Nusantara',
      'jamOperasional': '24 jam setiap hari',
      'keterangan': 'Permintaan layanan ambulans untuk kondisi darurat warga.',
    },
  ];

  static const List<Map<String, String>> _transportasi = [
    {
      'namaLayanan': 'Perpanjangan Kartu Bus Kota',
      'dinas': 'Dinas Perhubungan Kota Nusantara',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Perpanjangan kartu langganan bus kota Nusantara Cerdas.',
    },
    {
      'namaLayanan': 'Laporan Kerusakan Jalan',
      'dinas': 'Dinas Pekerjaan Umum dan Tata Ruang',
      'jamOperasional': 'Setiap hari, 08.00 - 20.00',
      'keterangan': 'Pelaporan kondisi jalan rusak agar segera ditindaklanjuti.',
    },
    {
      'namaLayanan': 'Informasi Rute Transportasi Umum',
      'dinas': 'Dinas Perhubungan Kota Nusantara',
      'jamOperasional': 'Setiap hari, 05.00 - 22.00',
      'keterangan': 'Informasi rute dan jadwal transportasi umum kota.',
    },
  ];

  // Membuka rincian layanan lewat named route, lalu menunggu (await) nilai
  // balik dari Navigator.pop pada tombol Ajukan Permohonan untuk ditampilkan
  // sebagai SnackBar.
  Future<void> _bukaRincian(Map<String, String> layanan) async {
    final hasil = await Navigator.pushNamed(
      context,
      AppRoutes.detailLayanan,
      arguments: layanan,
    );
    if (!mounted) return;
    if (hasil is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(hasil)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tanpa Scaffold, sebab halaman ini tampil di dalam Scaffold
    // milik KerangkaNavigasi.
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.description_outlined), text: 'Perizinan'),
              Tab(icon: Icon(Icons.local_hospital_outlined), text: 'Kesehatan'),
              Tab(icon: Icon(Icons.directions_bus_outlined), text: 'Transportasi'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buatDaftarLayanan(_perizinan),
                _buatDaftarLayanan(_kesehatan),
                _buatDaftarLayanan(_transportasi),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatDaftarLayanan(List<Map<String, String>> daftarLayanan) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: daftarLayanan.length,
      separatorBuilder: (context, indeks) => const Divider(height: 1),
      itemBuilder: (context, indeks) {
        final layanan = daftarLayanan[indeks];
        return ListTile(
          leading: const Icon(Icons.assignment_outlined),
          title: Text(layanan['namaLayanan'] ?? ''),
          subtitle: Text(layanan['dinas'] ?? ''),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _bukaRincian(layanan),
        );
      },
    );
  }
}
