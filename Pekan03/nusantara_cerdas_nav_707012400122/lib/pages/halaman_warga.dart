// lib/pages/halaman_warga.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorit_model.dart';
import '../models/layanan.dart';
import '../models/pengajuan_model.dart';
import '../widgets/buka_rincian.dart';
import '../widgets/tombol_favorit.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Warga Nusantara'),
            subtitle: Text('Akun warga • Smart City Nusantara'),
          ),
        ),
        const SizedBox(height: 16),

        // ---- Layanan Favorit (Consumer<FavoritModel>) ----
        Text('Layanan Favorit', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Consumer<FavoritModel>(
          builder: (context, favorit, child) {
            final daftar = daftarLayanan
                .where((layanan) => favorit.apakahFavorit(layanan.nama))
                .toList();

            if (daftar.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Belum ada layanan favorit. '
                    'Tandai bintang pada tujuan Layanan.',
                  ),
                ),
              );
            }

            return Column(
              children: [
                for (final layanan in daftar)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(layanan.ikon)),
                      title: Text(layanan.nama),
                      subtitle: Text(layanan.bidang),
                      trailing: TombolFavorit(namaLayanan: layanan.nama),
                      onTap: () => bukaRincianLayanan(context, layanan),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        // ---- Keranjang Pengajuan (Consumer<PengajuanModel>) ----
        Text('Keranjang Pengajuan', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Consumer<PengajuanModel>(
          builder: (context, pengajuan, child) {
            if (pengajuan.daftar.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Belum ada layanan yang diajukan.'),
                ),
              );
            }

            return Column(
              children: [
                for (final layanan in pengajuan.daftar)
                  Card(
                    child: ListTile(
                      leading: Icon(layanan.ikon),
                      title: Text(layanan.nama),
                      subtitle: Text(layanan.bidang),
                      trailing: IconButton(
                        tooltip: 'Hapus dari pengajuan',
                        onPressed: () => pengajuan.hapus(layanan.nama),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () {
                    final total = pengajuan.totalPengajuan;
                    pengajuan.kosongkan();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$total permohonan dikirim ke dinas terkait',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim Semua Pengajuan'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
