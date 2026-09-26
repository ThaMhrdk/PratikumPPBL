# LAPORAN MODUL II - SOAL 2
## Kerangka Desain Tugas Akhir Kutkatha

### Halaman Sampul

**Judul:** Kerangka Desain Tugas Akhir Aplikasi Kutkatha  
**Mata kuliah:** Pemrograman Perangkat Bergerak Lanjut (PPBL)  
**Nama:** Muhammad Anantha Mahardika Ridwan  
**NIM:** 707012400122  
**Program studi/kelas:** *(isi sesuai data kelas)*  
**Dosen pengampu:** *(isi sesuai data dosen)*  
**Perguruan tinggi:** *(isi nama institusi)*  
**Tahun akademik:** 2026

> Tambahkan logo institusi pada halaman sampul saat menyusun versi PDF.

## 1. Tujuan Praktikum

Praktikum ini bertujuan menyusun kerangka aplikasi Flutter multi-halaman yang mudah dipahami dan dikembangkan. Secara khusus, praktikum melatih penggunaan named route terpusat, pengiriman data antarhalaman, navigasi adaptif untuk berbagai ukuran layar, dan penyusunan tab untuk mengelompokkan informasi aplikasi.

## 2. Alat dan Bahan

- Laptop/PC dan perangkat Android atau browser Chrome untuk pengujian.
- Flutter SDK dan Dart SDK sesuai versi yang terpasang pada komputer.
- Visual Studio Code atau Android Studio.
- Git untuk menyimpan kode secara terpisah dari Soal 1.
- Proyek API PABW dan DPPB Kutkatha yang sudah tersedia.
- Folder proyek: `tubes_kutkatha_707012400122`.

## 3. Tema, Masalah, dan Pengguna

Kutkatha adalah aplikasi layanan kesehatan mental untuk masyarakat Kutai Kartanegara. Aplikasi ini menyelesaikan masalah sulitnya warga menemukan konsultasi psikolog, forum komunitas, dan artikel edukasi dalam alur yang teratur. Pengguna utamanya adalah warga yang membutuhkan akses informasi dan layanan kesehatan mental, sedangkan data layanan tetap dapat dikembangkan melalui API PABW dan DPPB yang telah terhubung.

## 4. Langkah-Langkah Praktikum

### 4.1 Membuat proyek dan folder

Proyek dibuat dengan nama berikut:

```powershell
flutter create tubes_kutkatha_707012400122
cd tubes_kutkatha_707012400122
mkdir lib/pages
mkdir lib/navigation
```

Pada proyek ini folder `lib/pages` berisi halaman kerangka tugas akhir dan detail layanan. Folder `lib/navigation` berisi satu pusat named route.

### 4.2 Membuat named route terpusat

File `lib/navigation/app_routes.dart` menyimpan nama route dan pembangkit halaman. `main.dart` memasangnya melalui `onGenerateRoute` serta menyediakan `onUnknownRoute` agar kesalahan nama route menampilkan halaman yang informatif, bukan membuat aplikasi berhenti.

```dart
MaterialApp(
  initialRoute: AppRoutes.splash,
  onGenerateRoute: AppRouter.generateRoute,
  onUnknownRoute: AppRouter.unknownRoute,
)
```

### 4.3 Membuat navigasi adaptif

`KerangkaTugasAkhirPage` menggunakan `LayoutBuilder`. Layar sempit menampilkan `NavigationBar`, layar menengah menggunakan `NavigationDrawer`, dan layar lebar menggunakan `NavigationRail`. Ketiganya mengubah `_selectedIndex`, sehingga perubahan pilihan dapat diamati sebagai perubahan state.

### 4.4 Membuat push dan pop dengan data

Nama layanan dikirim ke halaman detail melalui named route:

```dart
final selected = await Navigator.pushNamed(
  context,
  AppRoutes.serviceDetail,
  arguments: serviceName,
);
```

Halaman detail mengirim data kembali ke halaman sebelumnya:

```dart
Navigator.pop(context, serviceName);
```

Nilai yang diterima kemudian ditampilkan menggunakan `SnackBar`.

### 4.5 Membuat tab navigation

`DefaultTabController` membagi informasi menjadi tab Tujuan, Pengguna, dan Teknologi. Pembagian ini membuat penjelasan aplikasi tidak menumpuk pada satu layar panjang.

### 4.6 Menggabungkan ke halaman aplikasi

Menu **Profil > Kerangka Tugas Akhir** pada `HomePage` membuka route `/tugas-akhir`. Halaman lama dan integrasi API tetap dipertahankan; Soal 2 hanya menambahkan kerangka desain yang terpisah dan dapat dikembangkan.

## 5. Hasil dan Dokumentasi Program

Ambil tangkapan layar berikut setelah aplikasi dijalankan:

1. **Gambar 1 - Halaman Kerangka Tugas Akhir:** tampilan beranda dengan ringkasan masalah, layanan utama, dan tab informasi.
2. **Gambar 2 - NavigationBar:** tampilan layar sempit dengan pilihan Beranda, Layanan, dan Profil.
3. **Gambar 3 - NavigationDrawer:** tampilan layar menengah dengan drawer navigasi.
4. **Gambar 4 - NavigationRail:** tampilan layar lebar dengan rail di sisi kiri.
5. **Gambar 5 - Halaman Detail Layanan:** detail setelah memilih salah satu layanan.
6. **Gambar 6 - Hasil pop dengan data:** `SnackBar` yang menampilkan layanan terpilih setelah kembali.
7. **Gambar 7 - onUnknownRoute:** halaman fallback ketika route tidak dikenal.

> Sisipkan file gambar pada bagian ini sebelum ekspor laporan ke PDF. Nama file yang disarankan: `01-beranda.png`, `02-navigation-bar.png`, `03-drawer.png`, `04-rail.png`, `05-detail.png`, `06-pop-data.png`, dan `07-unknown-route.png`.

## 6. Analisis dan Pembahasan

`KerangkaTugasAkhirPage` menggunakan `StatefulWidget` karena indeks navigasi berubah ketika pengguna memilih tujuan berbeda. Detail layanan menggunakan `StatelessWidget` karena isi halaman hanya bergantung pada data `serviceName` yang diterima melalui konstruktor. `AppRoutes` dipisahkan dari tampilan agar perubahan nama route tidak tersebar di banyak file.

NavigationBar sesuai untuk ponsel karena mudah dijangkau ibu jari. NavigationDrawer sesuai untuk layar menengah karena memberi ruang konten lebih luas, sedangkan NavigationRail sesuai untuk desktop/tablet karena navigasi tetap terlihat di sisi kiri. Tab navigation dipilih untuk mengelompokkan informasi yang setara.

Kendala yang perlu diperhatikan adalah route dengan argumen harus memeriksa tipe data sebelum membuat halaman. Pemeriksaan nullable pada `app_routes.dart` mencegah cast yang salah. `onUnknownRoute` menangani route yang salah tulis. Keterkaitan dengan smart city tampak pada pilar masyarakat cerdas dan kehidupan cerdas: warga memperoleh layanan kesehatan mental, edukasi, dan ruang komunitas secara digital.

## 7. Kesimpulan

Kerangka desain tugas akhir Kutkatha telah dibuat sebagai proyek Flutter terpisah dengan struktur `lib/pages` dan `lib/navigation`. Aplikasi memenuhi named routes, push/pop dengan data, NavigationBar, NavigationDrawer, NavigationRail adaptif, tab navigation, dan `onUnknownRoute`. Kerangka ini dapat dilanjutkan dengan mengisi data nyata dari API PABW dan DPPB tanpa mengubah pola navigasi yang sudah disusun.

## 8. Lampiran Link Repositori GitHub

Kode Soal 2 pada folder ini dibuat terpisah dari repositori Soal 1. Isi tautan repositori GitHub yang sudah disediakan/digunakan pada tugas PABW atau DPPB:

`https://kutkatha.sisteminformasikotacerdas.id/`

> Jika dosen meminta URL repositori GitHub, tempelkan URL GitHub yang benar pada bagian ini; alamat website di atas adalah alamat aplikasi PABW, bukan URL GitHub.

## 9. Presentasi Hasil Praktikum

Saat presentasi, demonstrasikan alur berikut: buka menu Kerangka Tugas Akhir, pindah antar tujuan navigasi, buka detail layanan, pilih layanan untuk menguji nilai balik `pop`, tampilkan tab informasi, ubah ukuran layar untuk menunjukkan NavigationBar/Drawer/Rail, lalu buka route yang salah untuk menunjukkan `onUnknownRoute`.
