# Kerangka Desain Tugas Besar — tubes_kutkatha_707012400122

Modul II Soal 2 • Kerangka Desain Tugas Akhir (melanjutkan Tugas PABW)
Muhammad Anantha Mahardika Ridwan — NIM 707012400122

## Paragraf tema (untuk laporan)

Kutkatha (Kutai Kathana) adalah platform digital layanan psikologis
terintegrasi untuk masyarakat Kabupaten Kutai Kartanegara, melanjutkan
Tugas PABW yang backend-nya (Laravel) sudah berjalan di
kutkatha.sisteminformasikotacerdas.id dan sudah memiliki klien mobile
(kutkatha_mobile) yang API-nya terhubung ke backend tersebut. Pengguna
aplikasi ini adalah warga yang ingin mencari psikolog sesuai
spesialisasi, mengajukan booking konsultasi, serta berdiskusi lewat
forum komunitas kesehatan mental. Proyek `tubes_kutkatha_707012400122`
ini adalah kerangka desain navigasi yang terpisah dan ringan (isi
halaman masih berupa data tetap di dalam kode), dibuat khusus untuk
memenuhi Soal 2 Modul II — bukan pengganti/pengubah kode pada repo
`kutkatha_mobile` yang sesungguhnya.

## Cara menjalankan

```
flutter create .
flutter pub get
flutter run
```

## Struktur folder

```
tubes_kutkatha_707012400122/
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── navigation/
    │   ├── app_routes.dart        # konstanta route, daftarRoute,
    │   │                           # bentukRoute, routeTidakDikenal
    │   └── kerangka_navigasi.dart # NavigationBar + NavigationDrawer
    └── pages/
        ├── halaman_beranda.dart          # tujuan: Beranda
        ├── halaman_forum.dart            # tujuan: Forum
        ├── halaman_forum_detail.dart     # dibuka dari Forum (named route + arguments)
        ├── halaman_psikolog.dart         # dibuka dari Beranda
        ├── halaman_detail_psikolog.dart  # dibuka dari daftar psikolog
        ├── halaman_profil.dart           # tujuan: Profil
        ├── halaman_pengaturan.dart       # menu pendukung (drawer)
        ├── halaman_tentang_aplikasi.dart # menu pendukung (drawer)
        └── halaman_keluar.dart           # menu pendukung (drawer)
```

## Teknik navigasi yang diterapkan (minimal 3, di sini ada 4)

1. **Named routes** — seluruh perpindahan halaman penuh lewat `app_routes.dart` (wajib).
2. **Push & pop dengan pengiriman data** — daftar Psikolog → Rincian Psikolog
   (data dikirim lewat `arguments`) → tombol "Ajukan Booking" mengirim nilai
   balik lewat `Navigator.pop(context, pesan)`, ditampilkan sebagai SnackBar
   di halaman daftar. Pola yang sama juga dipakai Forum → Rincian Forum.
3. **NavigationBar** — 3 tujuan utama: Beranda, Forum, Profil.
4. **NavigationDrawer** — 3 tujuan utama yang sama + menu pendukung
   (Pengaturan, Tentang Aplikasi, Keluar).

## Peta navigasi (bahan diagram alur navigasi pada laporan)

| Halaman | Cara dibuka | Menambah tumpukan route? |
|---|---|---|
| Beranda | tujuan utama NavigationBar/Drawer (indeks 0) | Tidak |
| Forum | tujuan utama NavigationBar/Drawer (indeks 1) | Tidak |
| Profil | tujuan utama NavigationBar/Drawer (indeks 2) | Tidak |
| Daftar Psikolog | `pushNamed` dari kartu "Cari Psikolog" di Beranda | Ya |
| Rincian Psikolog | `pushNamed` dari item pada Daftar Psikolog | Ya |
| Rincian Forum | `pushNamed` dari topik pada Forum | Ya |
| Pengaturan | `pushNamed` dari Drawer / menu di Profil | Ya |
| Tentang Aplikasi | `pushNamed` dari Drawer / menu di Profil | Ya |
| Keluar | `pushNamed` dari Drawer / menu di Profil | Ya |
| Route Tidak Ditemukan | otomatis lewat `onUnknownRoute` | Ya |

## Checklist tangkapan layar

- [ ] Beranda
- [ ] Forum (daftar topik)
- [ ] Rincian Forum
- [ ] Profil
- [ ] Drawer dalam keadaan terbuka
- [ ] Daftar Psikolog
- [ ] Rincian Psikolog
- [ ] SnackBar hasil booking (setelah "Ajukan Booking Konsultasi")
- [ ] Pengaturan, Tentang Aplikasi, Keluar
- [ ] Halaman "Route Tidak Ditemukan" (tombol uji di Pengaturan, boleh dihapus setelahnya)
