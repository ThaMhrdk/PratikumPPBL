// lib/pages/halaman_jadwal.dart
import 'package:flutter/material.dart';

class HalamanJadwal extends StatelessWidget {
  const HalamanJadwal({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.today), text: 'Senin'),
              Tab(icon: Icon(Icons.event), text: 'Rabu'),
              Tab(icon: Icon(Icons.event_available), text: 'Jumat'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buatDaftarJadwal(const [
                  'Basis Data 07.00',
                  'Matematika Diskrit 10.00',
                ]),
                _buatDaftarJadwal(const ['PPB Lanjut 08.00', 'Jaringan 13.00']),
                _buatDaftarJadwal(const ['Kecerdasan Artifisial 09.00']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatDaftarJadwal(List<String> daftarJadwal) {
    return ListView.separated(
      itemCount: daftarJadwal.length,
      separatorBuilder: (context, indeks) => const Divider(height: 1),
      itemBuilder: (itemContext, indeks) {
        return ListTile(
          leading: const Icon(Icons.book_outlined),
          title: Text(daftarJadwal[indeks]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(
              itemContext,
              '/detail',
              arguments: {
                'judul': daftarJadwal[indeks],
                'keterangan': 'Rincian jadwal perkuliahan beserta ruang dan dosen pengampu.',
              },
            );
          },
        );
      },
    );
  }
}
