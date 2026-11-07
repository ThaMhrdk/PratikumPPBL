# Simulasi Soal & Panduan Asesmen 1 Praktikum PPBL (Konteks: Nusantara Cerdas)

Folder ini berisi proyek latihan lengkap **`nusantara_asesmen_707012400122`** yang dirancang mengikuti **100% Kisi-Kisi Asesmen Praktikum PPBL** (Pertemuan 1–6) dengan konteks **Aplikasi Layanan Warga Smart City "Nusantara Cerdas Mobile"**, serta menggunakan **BLoC (+30 Poin)**.

---

## 1. Contoh Soal Asesmen (Mirip Jurnal Praktikum — Versi Poin-Poin)

### Studi Kasus: Aplikasi Pengajuan & Pemantauan Layanan Warga "Nusantara Cerdas Mobile"

**Skenario Aplikasi (Soal Cerita Poin-Poin):**
- Dinas Komunikasi dan Informatika Kota Nusantara membutuhkan aplikasi **Nusantara Cerdas Mobile** agar warga dapat mengajukan permohonan layanan publik, memantau kuota berkas harian balai kota, dan melihat grafik statistik pengajuan per bidang layanan.
- Halaman utama aplikasi memiliki **2 menu tab di bagian bawah layar** (`NavigationBar`), yaitu tab **Pengajuan Warga** dan tab **Grafik Kota**, serta menggunakan `IndexedStack` agar isi halaman tidak hilang saat pengguna berpindah tab.
- Pada ikon tab **Pengajuan Warga**, tampilkan `Badge` yang menunjukkan jumlah permohonan layanan yang tercatat saat ini.
- Di halaman **Pengajuan Warga**, tampilkan bilah progres (`LinearProgressIndicator`) kuota berkas harian balai kota (maksimal 50 berkas), saringan (*filter*) per bidang layanan (`Semua`, `Perizinan`, `Kesehatan`, `Transportasi`), serta daftar permohonan menggunakan `ListView.builder` dan kotak konfirmasi hapus (`AlertDialog`).
- Pengguna dapat menekan tombol melayang (`FloatingActionButton`) **"+ Ajukan Layanan"** untuk berpindah ke halaman **Form Pengajuan** melalui *named route* (`/tambah`).
- Pada halaman **Form Pengajuan**, warga mengisi:
  1. `TextField` **Nama Lengkap Warga** dan **Nama Layanan Publik** (tidak boleh kosong).
  2. `TextField` **Jumlah Berkas Lampiran** (harus berupa angka bulat > 0).
  3. `DropdownButtonFormField` **Bidang Layanan** (`Perizinan`, `Kesehatan`, `Transportasi`).
  4. `RadioListTile` **Tingkat Urgensi** (`Biasa`, `Penting`, `Darurat`).
  5. `CheckboxListTile` **Persetujuan Data Pribadi Warga**.
- Tombol **Kirim Pengajuan Layanan** hanya aktif apabila seluruh isian valid dan kotak persetujuan telah dicentang. Saat dikirim, aplikasi menampilkan `SnackBar` dan kembali ke halaman utama (`Navigator.pop`).
- Di halaman **Grafik Kota**, tampilkan grafik batang (`BarChart` dari paket `fl_chart`) yang otomatis berubah mengikuti jumlah pengajuan pada tiap bidang layanan (dihitung menggunakan `Map`), dilengkapi tombol **Generate 5 Pengajuan Warga Acak** (`Random` dari `dart:math` & `List.generate()`).
- Aplikasi menyediakan **Mode Terang dan Mode Gelap** (`ThemeData` & `ColorScheme.fromSeed`) yang dapat diganti secara langsung menggunakan tombol `Switch` pada `AppBar`.

---

## 2. Pemetaan Kisi-Kisi Dosen ke File Proyek

| Bagian Kisi-Kisi | Bobot | File Implementasi pada Proyek | Detail Poin yang Dicakup |
| :--- | :---: | :--- | :--- |
| **1. Membuat Proyek & Berpindah Halaman** | **20%** | `pubspec.yaml`, `lib/main.dart`, folder `models/`, `pages/`, `state/`, `widgets/` | Pemisahan 4 folder, `StatelessWidget` & `StatefulWidget` (`setState`), `Scaffold`, `AppBar`, `Column`, `Row`, `Card`, `Padding`, `ListView`, `Navigator.pushNamed` & `Navigator.pop`, *named routes* (`routes`), `NavigationBar`, `IndexedStack`. |
| **2. Form Isian & Logika Dasar** | **25%** | `lib/pages/halaman_form_pengajuan.dart`, `lib/models/pengajuan_nusantara.dart` | `TextField`, `DropdownButtonFormField`, `RadioListTile`, `CheckboxListTile`, `TextEditingController` + `dispose()`, validasi angka (`int.tryParse`) & kosong, tombol aktif/nonaktif, `SnackBar`, `AlertDialog`, `FloatingActionButton`, logika `if/else`, `switch`, dan `Map`. |
| **3. Mengelola Data Aplikasi / State Management** | **25% (+30 Poin)** | `lib/state/nusantara_bloc.dart`, `lib/state/theme_bloc.dart`, `lib/state/nusantara_provider.dart` | State lokal vs state global, class model dengan konstruktor/properti/getter, **BLoC dengan Event & State (+30 poin)**, `Cubit` (`emit` + `BlocBuilder`), `Provider` (`ChangeNotifier` + `notifyListeners`), olah `List` (tambah, hapus, filter, hitung jumlah), `ListView.builder`, `LinearProgressIndicator`, `Badge`. |
| **4. Data Acak & Grafik** | **15%** | `lib/state/nusantara_bloc.dart`, `lib/pages/halaman_statistik_kota.dart` | `Random` dari `dart:math`, `List.generate()` untuk membuat 5 data warga sekaligus, `flutter pub add fl_chart`, hitung jumlah per kategori dengan `Map<String, int>`, grafik batang `BarChart` (`fl_chart`) yang reaktif. |
| **5. Tema Aplikasi & Widget Buatan Sendiri** | **15%** | `lib/main.dart`, `lib/widgets/kartu_kuota_layanan.dart`, `lib/widgets/kartu_pengajuan_warga.dart` | `ThemeData` + `ColorScheme.fromSeed()`, `theme`, `darkTheme`, `themeMode`, tombol `Switch` mode terang/gelap, `Theme.of(context)`, 2 custom widget reusable dengan parameter, anti-overflow (`Expanded`, `Flexible`, `SingleChildScrollView`). |

---

## 3. Cara Menjalankan Proyek

Buka terminal pada folder proyek ini lalu jalankan:

```powershell
cd "d:\Kuliah\Semester 5\PratikumPPBL\Simulasi_Asesmen1\nusantara_asesmen_707012400122"
flutter pub get
flutter run -d chrome
```
