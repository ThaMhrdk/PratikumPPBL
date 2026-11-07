# Nusantara Cerdas Mobile — nusantara_cerdas_nav_707012400122

Modul II • Navigasi dan Routing pada Aplikasi Flutter
Muhammad Anantha Mahardika Ridwan — NIM 707012400122

## Cara menjalankan

1. Pastikan `flutter doctor` sudah bersih.
2. Dari folder proyek ini, jalankan:
   ```
   flutter pub get
   flutter run
   ```
3. Untuk menguji tata letak layar lebar, jalankan `flutter run -d chrome`
   lalu lebarkan jendela melewati 600 piksel logis.

Jika Anda lebih nyaman memulai dari `flutter create` (disarankan agar
berkas platform Android/iOS/web ikut dibuat otomatis), jalankan:
```
flutter create nusantara_cerdas_nav_707012400122
```
lalu timpa folder `lib/` dan `pubspec.yaml` hasil `flutter create` dengan
isi dari paket ini (cukup ganti bagian `name:` pada pubspec bawaan bila
belum sama).

## Struktur folder

```
nusantara_cerdas_nav_707012400122/
├── pubspec.yaml
└── lib/
    ├── main.dart                        # MaterialApp + konfigurasi route
    ├── navigation/
    │   ├── app_routes.dart              # konstanta route, daftarRoute,
    │   │                                 # bentukRoute, routeTidakDikenal
    │   └── kerangka_navigasi.dart       # NavigationBar/Rail adaptif + Drawer
    └── pages/
        ├── halaman_beranda.dart         # tujuan: Beranda
        ├── halaman_layanan.dart         # tujuan: Layanan (3 tab)
        ├── halaman_rincian_layanan.dart # dibuka dari daftar layanan
        ├── halaman_warga.dart           # tujuan: Warga
        ├── halaman_riwayat_laporan.dart # dibuka dari Warga (BottomAppBar+FAB)
        ├── halaman_pengaturan_kota.dart # menu pendukung (drawer)
        ├── halaman_tentang_aplikasi.dart# menu pendukung (drawer)
        └── halaman_keluar.dart          # menu pendukung (drawer)
```

## Peta navigasi (bahan diagram alur navigasi pada laporan)

| Halaman | Cara dibuka | Menambah tumpukan route? |
|---|---|---|
| Beranda | tujuan utama NavigationBar/Rail/Drawer (indeks 0) | Tidak — hanya mengganti isi Scaffold |
| Layanan | tujuan utama NavigationBar/Rail/Drawer (indeks 1) | Tidak — hanya mengganti isi Scaffold |
| Warga | tujuan utama NavigationBar/Rail/Drawer (indeks 2) | Tidak — hanya mengganti isi Scaffold |
| Rincian Layanan | `Navigator.pushNamed` dari item pada tab Layanan | Ya — punya tombol kembali otomatis |
| Riwayat Laporan | `Navigator.pushNamed` dari tombol pada Warga | Ya |
| Pengaturan Kota | `Navigator.pushNamed` dari menu pendukung Drawer | Ya |
| Tentang Aplikasi | `Navigator.pushNamed` dari menu pendukung Drawer | Ya |
| Keluar | `Navigator.pushNamed` dari menu pendukung Drawer | Ya |
| Route Tidak Ditemukan | otomatis lewat `onUnknownRoute` | Ya |

Tab Perizinan/Kesehatan/Transportasi pada halaman Layanan **bukan** route —
TabBarView hanya mengganti isi di dalam satu halaman yang sama.

## Daftar tangkapan layar yang perlu diambil (sesuai Luaran)

- [ ] Beranda (ringkasan enam pilar)
- [ ] Layanan — tab Perizinan
- [ ] Layanan — tab Kesehatan
- [ ] Layanan — tab Transportasi
- [ ] Warga
- [ ] Drawer dalam keadaan terbuka
- [ ] Halaman Rincian Layanan
- [ ] SnackBar pemberitahuan hasil pengajuan (setelah menekan Ajukan Permohonan)
- [ ] Halaman Riwayat Laporan (BottomAppBar + FloatingActionButton)
- [ ] Tampilan layar lebar dengan NavigationRail (Chrome, lebar ≥ 600px)
- [ ] Halaman "Route Tidak Ditemukan" (tekan tombol "Uji Route Tidak
      Terdaftar" di Pengaturan Kota, lalu boleh dihapus tombolnya)
