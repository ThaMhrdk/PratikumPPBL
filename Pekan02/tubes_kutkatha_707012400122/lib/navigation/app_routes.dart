import 'package:flutter/material.dart';
import '../pages/halaman_psikolog.dart';
import '../pages/halaman_detail_psikolog.dart';
import '../pages/halaman_forum_detail.dart';
import '../pages/halaman_pengaturan.dart';
import '../pages/halaman_tentang_aplikasi.dart';
import '../pages/halaman_keluar.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  // Route akar, mengarah ke kerangka navigasi.
  static const String beranda = '/';

  // Route halaman penuh yang dibuka melalui Navigator.pushNamed.
  static const String psikologList = '/psikolog';
  static const String psikologDetail = '/psikolog/detail';
  static const String forumDetail = '/forum/detail';
  static const String pengaturan = '/pengaturan';
  static const String tentangAplikasi = '/tentang-aplikasi';
  static const String keluar = '/keluar';

  // Route tanpa argumen didaftarkan di sini.
  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      psikologList: (context) => const HalamanPsikolog(),
      pengaturan: (context) => const HalamanPengaturan(),
      tentangAplikasi: (context) => const HalamanTentangAplikasi(),
      keluar: (context) => const HalamanKeluar(),
    };
  }

  // Route yang memerlukan argumen dibentuk di sini.
  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    if (settings.name == psikologDetail) {
      final argumen = settings.arguments as Map<String, String>? ?? const {};
      return MaterialPageRoute(
        builder: (context) => HalamanDetailPsikolog(
          nama: argumen['nama'] ?? 'Tanpa Nama',
          spesialisasi: argumen['spesialisasi'] ?? '-',
          jadwal: argumen['jadwal'] ?? '-',
          keterangan: argumen['keterangan'] ?? 'Tidak ada keterangan.',
        ),
      );
    }
    if (settings.name == forumDetail) {
      final argumen = settings.arguments as Map<String, String>? ?? const {};
      return MaterialPageRoute(
        builder: (context) => HalamanForumDetail(
          judul: argumen['judul'] ?? 'Tanpa Judul',
          penulis: argumen['penulis'] ?? 'Warga',
          isi: argumen['isi'] ?? 'Tidak ada isi.',
        ),
      );
    }
    return null;
  }

  // Dipakai ketika nama route tidak terdaftar, agar aplikasi tidak
  // berhenti paksa saat nama route salah tulis.
  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Route Tidak Ditemukan')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text(
                  'Route "${settings.name}" belum terdaftar.',
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
