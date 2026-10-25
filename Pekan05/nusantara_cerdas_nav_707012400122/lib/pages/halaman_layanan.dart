import 'package:flutter/material.dart';
import '../data/data_layanan.dart';
import '../navigation/app_routes.dart';
import '../widgets/tombol_favorit.dart';

class HalamanLayanan extends StatefulWidget {
  const HalamanLayanan({super.key});

  @override
  State<HalamanLayanan> createState() => _HalamanLayananState();
}

class _HalamanLayananState extends State<HalamanLayanan> {
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
                _buatDaftarLayanan(DataLayanan.perizinan),
                _buatDaftarLayanan(DataLayanan.kesehatan),
                _buatDaftarLayanan(DataLayanan.transportasi),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatDaftarLayanan(List<Map<String, String>> daftarLayanan) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: daftarLayanan.length,
      separatorBuilder: (context, indeks) => const SizedBox(height: 4),
      itemBuilder: (context, indeks) {
        final layanan = daftarLayanan[indeks];
        final namaLayanan = layanan['namaLayanan'] ?? '';
        return Card(
          child: ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: Text(namaLayanan),
            subtitle: Text(layanan['dinas'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon bintang favorit (FavoritCubit melalui BlocSelector).
                TombolFavorit(namaLayanan: namaLayanan),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _bukaRincian(layanan),
          ),
        );
      },
    );
  }
}
