import 'package:flutter/material.dart';

class HalamanRiwayatLaporan extends StatelessWidget {
  const HalamanRiwayatLaporan({super.key});

  static const List<Map<String, String>> _riwayat = [
    {
      'judul': 'Permohonan izin usaha telah diajukan',
      'tanggal': '12 Sep 2026',
      'status': 'Diproses',
    },
    {
      'judul': 'Laporan kerusakan jalan telah diajukan',
      'tanggal': '02 Sep 2026',
      'status': 'Selesai',
    },
    {
      'judul': 'Pendaftaran puskesmas online telah diajukan',
      'tanggal': '28 Agu 2026',
      'status': 'Selesai',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Laporan')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _riwayat.length,
        separatorBuilder: (context, indeks) => const Divider(height: 1),
        itemBuilder: (context, indeks) {
          final item = _riwayat[indeks];
          return ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(item['judul'] ?? ''),
            subtitle: Text(item['tanggal'] ?? ''),
            trailing: Chip(label: Text(item['status'] ?? '')),
          );
        },
      ),
      // Tombol melayang yang menempel pada cekungan BottomAppBar.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buat laporan baru')),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // BottomAppBar berisi aksi (bukan tujuan navigasi utama), minimal
      // tiga ikon aksi sesuai ketentuan modul praktikum.
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Cari laporan',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Saring status',
              onPressed: () {},
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.sort),
              tooltip: 'Urutkan',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Lainnya',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
