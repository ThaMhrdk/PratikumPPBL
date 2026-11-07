import 'package:flutter/material.dart';
import '../model/konsultasi_model.dart';
import '../pages/halaman_detail_konsultasi.dart';
import '../pages/halaman_detail_psikolog.dart';
import '../pages/halaman_formulir_konseling.dart';
import '../pages/halaman_keluar.dart';
import '../pages/halaman_pengaturan.dart';
import '../pages/halaman_psikolog.dart';
import '../pages/halaman_tentang_aplikasi.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  static const String beranda = '/';
  static const String psikologList = '/psikolog';
  static const String psikologDetail = '/psikolog/detail';
  static const String formulirKonseling = '/formulir-konseling';
  static const String detailKonsultasi = '/konsultasi/detail';
  static const String pengaturan = '/pengaturan';
  static const String tentangAplikasi = '/tentang-aplikasi';
  static const String keluar = '/keluar';

  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      psikologList: (context) => Scaffold(
            appBar: AppBar(title: const Text('Daftar Psikolog Mitra')),
            body: const HalamanPsikolog(),
          ),
      pengaturan: (context) => const HalamanPengaturan(),
      tentangAplikasi: (context) => const HalamanTentangAplikasi(),
      keluar: (context) => const HalamanKeluar(),
    };
  }

  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    if (settings.name == formulirKonseling) {
      final argumen = settings.arguments as Map<String, String>? ?? const {};
      return MaterialPageRoute(
        builder: (context) => HalamanFormulirKonseling(
          namaPsikolog: argumen['namaPsikolog'] ?? 'Muhammad Anantha M. R., M.Psi., Psikolog',
          spesialisasi: argumen['spesialisasi'] ?? 'Psikolog Klinis Dewasa & Kecemasan',
        ),
      );
    }

    if (settings.name == psikologDetail) {
      final argumen = settings.arguments as Map<String, String>? ?? const {};
      return MaterialPageRoute(
        builder: (context) => HalamanDetailPsikolog(
          nama: argumen['nama'] ?? 'Muhammad Anantha M. R., M.Psi., Psikolog',
          spesialisasi: argumen['spesialisasi'] ?? 'Psikolog Klinis Dewasa & Kecemasan',
          jadwal: argumen['jadwal'] ?? 'Senin & Rabu, 09.00 - 15.00 WITA',
          keterangan: argumen['keterangan'] ?? 'Menangani kecemasan dan manajemen emosi.',
        ),
      );
    }

    if (settings.name == detailKonsultasi) {
      final sesi = settings.arguments as SesiKonsultasi;
      return MaterialPageRoute(
        builder: (context) => HalamanDetailKonsultasi(sesi: sesi),
      );
    }

    return null;
  }

  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Rute Tidak Dikenal')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.deepPurple),
                const SizedBox(height: 12),
                Text('Rute "${settings.name}" belum terdaftar.'),
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
