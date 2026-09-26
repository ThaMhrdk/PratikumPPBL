# Praktikum PPBL Modul II - Soal 2

**Nama:** Muhammad Anantha Mahardika Ridwan  
**NIM:** 707012400122  
**Nama proyek:** `tubes_kutkatha_707012400122`  
**Tema:** Kutkatha, layanan kesehatan mental untuk masyarakat Kutai Kartanegara

## Latar belakang dan pengguna

Kutkatha menyelesaikan masalah sulitnya warga memperoleh akses terarah ke layanan kesehatan mental, informasi edukatif, dan ruang komunitas dalam satu aplikasi. Pengguna utama aplikasi ini adalah masyarakat Kutai Kartanegara yang membutuhkan konsultasi psikolog, forum diskusi, artikel edukasi, serta pengelolaan booking; aplikasi Flutter ini meneruskan integrasi API PABW dan DPPB yang telah tersedia.

## Implementasi ketentuan Soal 2

- **Named routes:** semua halaman tugas akhir didaftarkan di `lib/navigation/app_routes.dart`.
- **Push/pop dengan data:** kartu layanan mengirim nama layanan melalui `Navigator.pushNamed`, halaman detail mengembalikan pilihan dengan `Navigator.pop(context, value)`.
- **NavigationBar:** dipakai pada layar sempit.
- **NavigationDrawer:** dipakai pada layar menengah.
- **NavigationRail adaptif:** dipakai pada layar lebar, dengan label extended pada layar sangat lebar.
- **Tab navigation:** tab Tujuan, Pengguna, dan Teknologi pada halaman beranda tugas akhir.
- **onUnknownRoute:** menampilkan halaman informasi ketika nama route salah atau tidak tersedia.

## Struktur folder yang dibuat

```text
lib/
├── navigation/
│   └── app_routes.dart
└── pages/
    ├── detail_layanan_page.dart
    └── kerangka_tugas_akhir.dart
```

File aplikasi yang diintegrasikan:

- `lib/main.dart` mendaftarkan `onUnknownRoute`.
- `lib/core/app_router.dart` mengekspor router baru agar kode lama tetap kompatibel.
- `lib/mvc/home/view/home_page.dart` menambahkan akses **Profil > Kerangka Tugas Akhir**.

## Menjalankan dan pengujian

```powershell
cd 'D:\Kuliah\Semester 5\PPBL\tubes_kutkatha_707012400122'
flutter pub get
flutter run
```

Setelah login, buka **Profil > Kerangka Tugas Akhir**. Uji perubahan state dengan memilih Beranda, Layanan, dan Profil. Uji push/pop dengan memilih salah satu layanan lalu menekan **Pilih layanan**. Uji fallback dengan membuka route yang tidak terdaftar.

## Bahan laporan

Laporan lengkap tersedia pada `LAPORAN_Modul2_Soal2_707012400122_Muhammad_Anantha_Mahardika_Ridwan.md`. Tambahkan tangkapan layar aplikasi pada bagian dokumentasi sebelum mengubahnya menjadi PDF dan mengunggahnya ke LMS. Kode pada folder ini sengaja dibuat terpisah dari repositori GitHub yang sudah ada.
