# Catatan Laporan Modul 5 – Tugas Praktikum (Bagian G)

**Nama:** Muhammad Anantha Mahardika Ridwan
**NIM:** 707012400122
**Materi:** State Management – Provider, Cubit, dan BLoC (paket `flutter_bloc`)

```
Pekan05/
├── CATATAN_LAPORAN.md                 <- berkas ini
├── nusantara_cerdas_nav_707012400122/ <- SOAL 1 (pakai CUBIT)
└── tubes_kutkatha_707012400122/       <- SOAL 2 (pakai CUBIT)
```

Kedua proyek adalah **lanjutan proyek Modul II (Pekan02)**. Kerangka navigasinya
(NavigationBar, NavigationDrawer, TabBar, NavigationRail, named routes) tetap
sama, hanya ditambah state management.

---

## SOAL 1 – nusantara_cerdas_nav_707012400122 (Cubit)

### Struktur folder `lib/`
```
lib/
├── main.dart                         (DIUBAH)  MultiBlocProvider di atas MaterialApp
├── cubit/                            (BARU)
│   ├── favorit_cubit.dart            FavoritCubit extends Cubit<Set<String>>
│   ├── pengajuan_state.dart          PengajuanState + getter totalPengajuan
│   └── pengajuan_cubit.dart          PengajuanCubit extends Cubit<PengajuanState>
├── data/
│   └── data_layanan.dart             (BARU)  data layanan 3 bidang (dipindah dari halaman_layanan)
├── widgets/                          (BARU)
│   ├── tombol_favorit.dart           ikon bintang -> BlocSelector + context.read()
│   └── ikon_warga_badge.dart         badge jumlah pengajuan -> BlocSelector
├── navigation/
│   ├── app_routes.dart               (tetap dari Modul II)
│   └── kerangka_navigasi.dart        (DIUBAH)  ikon Warga diganti IkonWargaBadge
└── pages/
    ├── halaman_beranda.dart          (sedikit diubah: childAspectRatio agar tidak overflow)
    ├── halaman_layanan.dart          (DIUBAH)  tiap kartu layanan diberi ikon bintang
    ├── halaman_rincian_layanan.dart  (DIUBAH)  Stateful, _sedangMengirim pakai setState()
    ├── halaman_warga.dart            (DIUBAH)  bagian Daftar Pengajuan + Layanan Favorit (BlocBuilder)
    └── (halaman lain tetap dari Modul II)
test/widget_test.dart                 (BARU) uji Cubit + uji layar sempit & lebar
```

### Pemetaan ketentuan soal → kode
| No | Ketentuan | Implementasi |
|---|---|---|
| 1 | Lanjutkan proyek Modul II | Disalin dari `Pekan02/nusantara_cerdas_nav_707012400122` |
| 2 | Pilih satu pendekatan | **Cubit** (tanpa Provider/ChangeNotifier) |
| 3 | FavoritCubit `Cubit<Set<String>>`, `tandai()`, `batalTandai()` | `lib/cubit/favorit_cubit.dart` – emit salinan Set baru |
| 4 | PengajuanCubit + turunan `totalPengajuan` | `lib/cubit/pengajuan_cubit.dart`, `pengajuan_state.dart` |
| 5 | MultiBlocProvider di atas MaterialApp | `lib/main.dart` |
| 6 | Ikon bintang di tujuan Layanan | `widgets/tombol_favorit.dart` (BlocSelector + `context.read<FavoritCubit>()`) |
| 7 | Bagian Layanan Favorit di Warga | `_BagianFavorit` di `halaman_warga.dart` (BlocBuilder) |
| 8 | Ajukan Permohonan: setState sedang mengirim → tambah ke Cubit → `Navigator.pop(context, nilai)` | `halaman_rincian_layanan.dart` |
| 9 | Badge pengajuan di ikon Warga pakai BlocSelector | `widgets/ikon_warga_badge.dart` (dipakai di NavigationBar, NavigationRail, Drawer) |
| 10 | Tidak ada galat "provider tidak ditemukan" | Provider di atas MaterialApp → semua route & layar lebar aman (diuji di `test/`) |

### Alasan pemilihan (untuk bagian Analisis & Pembahasan)
- **setState() untuk `_sedangMengirim`** – hanya dipakai tombol di halaman rincian, hilang saat halaman ditutup, tidak perlu diketahui halaman lain → state lokal.
- **Cubit untuk favorit & pengajuan** – data dipakai bersama oleh tujuan Layanan, halaman Rincian, tujuan Warga, dan badge navigasi. Logikanya sederhana (tambah/hapus), jadi Cubit cukup dan lebih ringkas daripada BLoC (tidak perlu kelas Event). Sesuai pedoman modul: *"jika masih ragu, mulailah dengan Cubit"*.
- **BlocBuilder** – bagian Layanan Favorit & Daftar Pengajuan di Warga, karena seluruh daftar harus digambar ulang.
- **context.read()** – di `onPressed` (tandai, batalTandai, ajukan, batalkan, kirimSemua) karena hanya memanggil method, tidak mendengarkan state.
- **BlocSelector** – ikon bintang (hanya memilih `bool` favorit layanan itu) dan badge Warga (hanya memilih `int totalPengajuan`), sehingga NavigationBar/NavigationRail tidak ikut dibangun ulang.

### Tangkapan layar yang perlu diambil (layar sempit **dan** layar lebar / Chrome)
1. Tujuan Layanan sebelum ditandai favorit (bintang kosong).
2. Setelah ditandai favorit (bintang kuning) – coba di tab Perizinan, Kesehatan, Transportasi.
3. Tujuan Warga → bagian **Layanan Favorit** berisi layanan dari beberapa bidang.
4. Halaman rincian saat tombol menampilkan **"Sedang mengirim..."** (indikator berputar ±1,5 detik).
5. SnackBar nilai balik + **badge angka** pada ikon Warga (buka dari Beranda/Layanan agar terlihat badge tetap tampil).
6. Badge bertambah setelah mengajukan beberapa layanan; Daftar Pengajuan di Warga; tombol "Kirim N Pengajuan Sekaligus".
7. Layar lebar (Chrome, lebar ≥ 600 px) – NavigationRail dengan badge.

---

## SOAL 2 – tubes_kutkatha_707012400122 (Cubit)

### Struktur folder `lib/`
```
lib/
├── main.dart                        (DIUBAH)  BlocProvider<BookingCubit> di atas MaterialApp
├── cubit/                           (BARU)
│   ├── booking_state.dart           ItemBooking, BookingState (+ totalBooking, sudahDibooking)
│   └── booking_cubit.dart           BookingCubit extends Cubit<BookingState>
├── widgets/
│   └── ikon_profil_badge.dart       (BARU)  badge jumlah booking -> BlocSelector
├── navigation/
│   └── kerangka_navigasi.dart       (DIUBAH) ikon Profil diganti IkonProfilBadge
└── pages/
    ├── halaman_detail_psikolog.dart (DIUBAH) Stateful, _sedangMemproses (setState) + tambahBooking()
    ├── halaman_beranda.dart         (DIUBAH) kartu Booking Konsultasi menampilkan jumlah (BlocSelector)
    ├── halaman_profil.dart          (DIUBAH) bagian "Booking Konsultasi Saya" (BlocBuilder + batalkanBooking)
    └── (halaman lain tetap dari Modul II)
test/widget_test.dart                (BARU)
```

### Data lokal vs data bersama
| Data | Pengelola | Halaman | Alasan |
|---|---|---|---|
| `_sedangMemproses` (status memuat tombol booking) | **setState()** | Rincian Psikolog | Hanya penting untuk satu tombol di satu halaman |
| Daftar booking konsultasi | **BookingCubit** | Rincian Psikolog (`context.read` + `BlocSelector`), Beranda (`BlocSelector`), Profil (`BlocBuilder` + `context.read`), badge ikon Profil (`BlocSelector`) | Dipakai bersama oleh ≥ 2 halaman |

### Mengapa Cubit dipilih di Soal 2
- Logika pengelolaan daftar booking konsultasi (tambah booking, batalkan booking, hitung total) bersifat langsung dan terstruktur, sehingga penggunaan `Cubit` sudah sangat memadai tanpa perlu membuat kelas `Event` terpisah seperti pada BLoC.
- Menggunakan state immutable (`BookingState`) yang di-emit melalui `emit()`, sehingga mudah dilacak dan diuji sesuai pedoman pada Dasar Teori Modul 5.

### Tangkapan layar yang perlu diambil
1. Beranda sebelum booking ("Belum ada booking") dan Profil kosong ("Belum ada booking konsultasi").
2. Rincian Psikolog saat tombol **"Sedang memproses..."**.
3. Setelah booking: tombol berubah jadi "Sudah Dibooking", SnackBar, badge pada ikon Profil.
4. Beranda menampilkan "1 booking aktif" (atau lebih).
5. Profil menampilkan daftar booking; lalu setelah dibatalkan (badge berkurang).

---

## Cara menjalankan
```powershell
cd "D:\Kuliah\Semester 5\PratikumPPBL\Pekan05\nusantara_cerdas_nav_707012400122"
flutter pub get
flutter run            # emulator / HP
flutter run -d chrome  # peramban (uji layar lebar)
flutter test           # pengujian otomatis

cd ..\tubes_kutkatha_707012400122
flutter pub get
flutter run
```

## Hal yang masih perlu Saudara lengkapi sendiri
- **Push ke GitHub** (luaran wajib: kode di repositori Git) dan cantumkan link-nya di lampiran laporan.
- **Tangkapan layar** dari emulator/HP dan Chrome (tidak bisa saya ambil).
- Laporan PDF: `Modul5_707012400122_MuhammadAnanthaMahardikaRidwan.pdf` (Soal 1) dan `Modul5_Soal2_707012400122_MuhammadAnanthaMahardikaRidwan.pdf` (Soal 2).
- Data di Soal 2 masih **data contoh lokal** (diizinkan modul: *"Data yang dikelola boleh sementara atau contoh sederhana"*), belum memanggil API Kutkatha – sengaja agar tidak melenceng dari materi Modul 5.
