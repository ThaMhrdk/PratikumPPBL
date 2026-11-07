import 'package:flutter/material.dart';
import '../model/pengajuan_model.dart';
import '../pages/halaman_chat.dart';
import '../pages/halaman_peta.dart';
import '../pages/halaman_rincian_layanan.dart';
import '../pages/halaman_rincian_pengajuan.dart';
import '../pages/halaman_statistik.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  // Konstanta nama rute sesuai standar Modul II dan Modul IV
  static const String beranda = '/';
  static const String formulirPengajuan = '/formulir-pengajuan';
  static const String rincianPengajuan = '/rincian-pengajuan';
  static const String chat = '/chat';
  static const String peta = '/peta';
  static const String statistik = '/statistik';

  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      chat: (context) => const HalamanChat(),
      peta: (context) => const HalamanPeta(),
      statistik: (context) => const HalamanStatistik(),
    };
  }

  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    if (settings.name == formulirPengajuan) {
      final argumen = settings.arguments as Map<String, String>? ?? const {};
      return MaterialPageRoute(
        builder: (context) => HalamanRincianLayanan(
          namaLayanan: argumen['namaLayanan'] ?? 'Izin Usaha Mikro (IUMK)',
          bidang: argumen['bidang'] ?? 'Perizinan',
          dinas: argumen['dinas'] ?? 'Dinas Penanaman Modal dan PTSP',
          keterangan: argumen['keterangan'] ??
              'Layanan permohonan penerbitan surat izin usaha terpadu warga Kota Nusantara.',
        ),
      );
    }

    if (settings.name == rincianPengajuan) {
      final pengajuan = settings.arguments as Pengajuan;
      return MaterialPageRoute(
        builder: (context) => HalamanRincianPengajuan(pengajuan: pengajuan),
      );
    }

    return null;
  }

  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Rute Tidak Ditemukan')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text(
                  'Rute "${settings.name}" belum terdaftar pada AppRoutes.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
