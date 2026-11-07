import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorit_cubit.dart';
import '../cubit/pengajuan_cubit.dart';
import '../cubit/pengajuan_state.dart';
import '../data/data_layanan.dart';
import '../navigation/app_routes.dart';
import '../widgets/kartu_layanan.dart';
import '../widgets/sakelar_tema.dart';
import '../widgets/tombol_utama.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Kartu Profil Warga
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 42,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Muhammad Anantha Mahardika Ridwan',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIM: 707012400122 | Kelas BD4SC-48-REG-01',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'D4 Sistem Informasi Kota Cerdas',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Custom Widget SakelarTema untuk Toggle Mode Gelap/Terang
        const SakelarTema(),
        const SizedBox(height: 16),

        _buatJudulBagian(
          context,
          'Daftar Pengajuan',
          'Layanan yang akan diajukan sekaligus ke dinas terkait.',
        ),
        const SizedBox(height: 8),
        const _BagianPengajuan(),
        const SizedBox(height: 16),

        _buatJudulBagian(
          context,
          'Layanan Favorit',
          'Layanan yang ditandai bintang dari seluruh bidang layanan.',
        ),
        const SizedBox(height: 8),
        const _BagianFavorit(),
        const SizedBox(height: 16),

        _buatJudulBagian(
          context,
          'Riwayat Laporan & Pengaduan',
          'Lihat status permohonan dan laporan yang pernah diajukan.',
        ),
        const SizedBox(height: 10),
        TombolUtama(
          label: 'Lihat Riwayat Laporan',
          icon: Icons.history,
          isFullWidth: true,
          isOutlined: true,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.riwayatLaporan),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buatJudulBagian(
      BuildContext context, String judul, String keterangan) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            keterangan,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Bagian Daftar Pengajuan memakai BlocBuilder karena seluruh isi daftar
// harus digambar ulang setiap kali layanan ditambah, dibatalkan, atau dikirim.
class _BagianPengajuan extends StatelessWidget {
  const _BagianPengajuan();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PengajuanCubit, PengajuanState>(
      builder: (context, state) {
        if (state.daftarLayanan.isEmpty) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.inbox_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              title: const Text('Belum ada layanan yang diajukan'),
              subtitle: Text(
                'Buka rincian layanan lalu tekan Ajukan Permohonan.',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          );
        }
        return Card(
          child: Column(
            children: [
              for (final namaLayanan in state.daftarLayanan)
                ListTile(
                  leading: Icon(
                    Icons.assignment_turned_in_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(namaLayanan),
                  subtitle: Text(
                    DataLayanan.cari(namaLayanan)?['dinas'] ?? '',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  trailing: IconButton(
                    tooltip: 'Batalkan pengajuan',
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: () =>
                        context.read<PengajuanCubit>().batalkan(namaLayanan),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TombolUtama(
                  label: 'Kirim ${state.totalPengajuan} Pengajuan Sekaligus',
                  icon: Icons.send,
                  isFullWidth: true,
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
    final theme = Theme.of(context);

    return BlocBuilder<FavoritCubit, Set<String>>(
      builder: (context, favorit) {
        if (favorit.isEmpty) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.star_border,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              title: const Text('Belum ada layanan favorit'),
              subtitle: Text(
                'Tekan ikon bintang pada tujuan Layanan.',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          );
        }
        return Column(
          children: [
            for (final namaLayanan in favorit)
              KartuLayanan(
                layanan: DataLayanan.cari(namaLayanan) ??
                    {
                      'namaLayanan': namaLayanan,
                      'dinas': 'Dinas Terkait',
                      'bidang': 'Umum',
                    },
                onTap: () {
                  final layanan = DataLayanan.cari(namaLayanan);
                  if (layanan == null) return;
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detailLayanan,
                    arguments: layanan,
                  );
                },
                trailing: IconButton(
                  tooltip: 'Hapus dari favorit',
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: () =>
                      context.read<FavoritCubit>().batalTandai(namaLayanan),
                ),
              ),
          ],
        );
      },
    );
  }
}
