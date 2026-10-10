// lib/pages/halaman_layanan.dart
import 'package:flutter/material.dart';

import '../models/layanan.dart';
import '../widgets/buka_rincian.dart';
import '../widgets/tombol_favorit.dart';

class HalamanLayanan extends StatelessWidget {
  const HalamanLayanan({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: daftarBidang.length,
      child: Column(
        children: [
          TabBar(
            tabs: [for (final bidang in daftarBidang) Tab(text: bidang)],
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final bidang in daftarBidang)
                  _DaftarLayananBidang(bidang: bidang),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DaftarLayananBidang extends StatelessWidget {
  const _DaftarLayananBidang({required this.bidang});

  final String bidang;

  @override
  Widget build(BuildContext context) {
    final daftar = layananBidang(bidang).toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: daftar.length,
      separatorBuilder: (context, indeks) => const SizedBox(height: 8),
      itemBuilder: (context, indeks) {
        final layanan = daftar[indeks];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(layanan.ikon)),
            title: Text(layanan.nama),
            subtitle: Text(
              layanan.deskripsi,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: TombolFavorit(namaLayanan: layanan.nama),
            onTap: () => bukaRincianLayanan(context, layanan),
          ),
        );
      },
    );
  }
}
