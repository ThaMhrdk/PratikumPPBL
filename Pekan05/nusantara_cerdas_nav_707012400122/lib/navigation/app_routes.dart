import 'package:flutter/material.dart';
import '../pages/halaman_rincian_layanan.dart';
import '../pages/halaman_riwayat_laporan.dart';
import '../pages/halaman_pengaturan_kota.dart';
import '../pages/halaman_tentang_aplikasi.dart';
import '../pages/halaman_keluar.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  // Route akar, mengarah ke kerangka navigasi (bukan langsung ke satu halaman).
  static const String beranda = '/';

  // Route halaman penuh yang dibuka melalui Navigator.pushNamed.
  static const String detailLayanan = '/detail-layanan';
  static const String riwayatLaporan = '/riwayat-laporan';
  static const String pengaturanKota = '/pengaturan-kota';
  static const String tentangAplikasi = '/tentang-aplikasi';
  static const String keluar = '/keluar';

  // Route tanpa argumen didaftarkan di sini.
  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      riwayatLaporan: (context) => const HalamanRiwayatLaporan(),
      pengaturanKota: (context) => const HalamanPengaturanKota(),
      tentangAplikasi: (context) => const HalamanTentangAplikasi(),
      keluar: (context) => const HalamanKeluar(),
    };
  }

  // Route yang memerlukan argumen dibentuk di sini, bukan di daftarRoute().
  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    if (settings.name == detailLayanan) {
      final argumen = settings.arguments as Map<String, String>? ?? const {};
      return MaterialPageRoute(
        builder: (context) => HalamanRincianLayanan(
          namaLayanan: argumen['namaLayanan'] ?? 'Tanpa Nama',
          dinas: argumen['dinas'] ?? 'Tidak diketahui',
          jamOperasional: argumen['jamOperasional'] ?? '-',
          keterangan: argumen['keterangan'] ?? 'Tidak ada keterangan.',
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
