import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorit_cubit.dart';
import '../cubit/pengajuan_cubit.dart';
import '../cubit/pengajuan_state.dart';
import '../data/data_layanan.dart';
import '../navigation/app_routes.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  @override
  Widget build(BuildContext context) {
    // Tanpa Scaffold, sebab halaman ini tampil di dalam Scaffold
    // milik KerangkaNavigasi.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        const SizedBox(height: 12),
        const Center(child: Text('Muhammad Anantha Mahardika Ridwan')),
        const Center(child: Text('NIM 707012400122')),
        const SizedBox(height: 24),
        _buatJudulBagian(
          'Daftar Pengajuan',
          'Layanan yang akan diajukan sekaligus ke dinas terkait.',
        ),
        const SizedBox(height: 8),
        const _BagianPengajuan(),
        const SizedBox(height: 24),
        _buatJudulBagian(
          'Layanan Favorit',
          'Layanan yang ditandai bintang dari seluruh bidang layanan.',
        ),
        const SizedBox(height: 8),
        const _BagianFavorit(),
        const SizedBox(height: 24),
        _buatJudulBagian(
          'Riwayat Laporan',
          'Lihat status permohonan dan laporan yang pernah diajukan.',
        ),
        const SizedBox(height: 16),
        // Riwayat Laporan dibuka sebagai halaman penuh melalui named route,
        // sehingga menambah tumpukan route (berbeda dari tiga tujuan utama).
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.riwayatLaporan),
          icon: const Icon(Icons.history),
          label: const Text('Lihat Riwayat Laporan'),
        ),
      ],
    );
  }

  Widget _buatJudulBagian(String judul, String keterangan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          judul,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          keterangan,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}

// Bagian Daftar Pengajuan memakai BlocBuilder karena seluruh isi daftar
// harus digambar ulang setiap kali layanan ditambah, dibatalkan, atau dikirim.
class _BagianPengajuan extends StatelessWidget {
  const _BagianPengajuan();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PengajuanCubit, PengajuanState>(
      builder: (context, state) {
        if (state.daftarLayanan.isEmpty) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.inbox_outlined),
              title: Text('Belum ada layanan yang diajukan'),
              subtitle: Text('Buka rincian layanan lalu tekan Ajukan Permohonan.'),
            ),
          );
        }
        return Card(
          child: Column(
            children: [
              for (final namaLayanan in state.daftarLayanan)
                ListTile(
                  leading: const Icon(Icons.assignment_turned_in_outlined),
                  title: Text(namaLayanan),
                  subtitle: Text(DataLayanan.cari(namaLayanan)?['dinas'] ?? ''),
                  trailing: IconButton(
                    tooltip: 'Batalkan pengajuan',
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        context.read<PengajuanCubit>().batalkan(namaLayanan),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      final total = state.totalPengajuan;
                      context.read<PengajuanCubit>().kirimSemua();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$total permohonan berhasil dikirim ke dinas terkait.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: Text('Kirim ${state.totalPengajuan} Pengajuan Sekaligus'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Bagian Layanan Favorit memakai BlocBuilder agar daftar tampil reaktif,
// tanpa memandang tab bidang asal layanan (Perizinan/Kesehatan/Transportasi).
class _BagianFavorit extends StatelessWidget {
  const _BagianFavorit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritCubit, Set<String>>(
      builder: (context, favorit) {
        if (favorit.isEmpty) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.star_border),
              title: Text('Belum ada layanan favorit'),
              subtitle: Text('Tekan ikon bintang pada tujuan Layanan.'),
            ),
          );
        }
        return Card(
          child: Column(
            children: [
              for (final namaLayanan in favorit)
                ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(namaLayanan),
                  subtitle: Text(
                    'Bidang ${DataLayanan.cari(namaLayanan)?['bidang'] ?? '-'}',
                  ),
                  trailing: IconButton(
                    tooltip: 'Hapus dari favorit',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        context.read<FavoritCubit>().batalTandai(namaLayanan),
                  ),
                  onTap: () {
                    final layanan = DataLayanan.cari(namaLayanan);
                    if (layanan == null) return;
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailLayanan,
                      arguments: layanan,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
