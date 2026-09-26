# Nusantara Cerdas — nusantara_cerdas_707012400122

Modul I • Stateless Widget, Stateful Widget, Layout & Styling
Muhammad Anantha Mahardika Ridwan — NIM 707012400122

## Cara menjalankan

```
flutter pub get
flutter run
```

Kalau mau berkas Android/iOS/web ikut ter-generate otomatis, jalankan dulu
`flutter create nusantara_cerdas_707012400122`, lalu timpa folder `lib/`
dan `pubspec.yaml` bawaan dengan isi paket ini.

## Struktur folder

Modul ini mengajarkan pemisahan satu widget = satu berkas, langsung di
dalam `lib/` (tanpa subfolder `pages/`), persis pola pada bagian F modul.

```
nusantara_cerdas_707012400122/
├── pubspec.yaml
└── lib/
    ├── main.dart          # MaterialApp, ThemeData (colorSchemeSeed teal)
    ├── kepala_kota.dart   # StatelessWidget — identitas kota (tetap)
    ├── kartu_pilar.dart   # StatelessWidget — kartu 1 pilar smart city (tetap)
    ├── panel_laporan.dart # StatefulWidget — penghitung laporan warga (berubah)
    └── halaman_utama.dart # Menggabungkan ketiganya dengan Scaffold + SingleChildScrollView
```

## Alasan pemilihan StatelessWidget vs StatefulWidget (bahan laporan)

| Widget | Jenis | Alasan |
|---|---|---|
| `KepalaKota` | StatelessWidget | Nama kota, semboyan, dan ikon tidak pernah berubah selama aplikasi berjalan. |
| `KartuPilar` | StatelessWidget | Nama pilar, ikon, dan deskripsi bersifat tetap — hanya ditampilkan ulang dengan data berbeda lewat parameter. |
| `PanelLaporanWarga` | StatefulWidget | Jumlah laporan dan status pelayanan berubah setiap tombol ditekan, dan tampilan harus diperbarui lewat `setState()`. |
| `HalamanUtama` | StatelessWidget | Hanya menyusun tata letak (Column/Row/SingleChildScrollView); state sesungguhnya disimpan lokal di `PanelLaporanWarga`, bukan di halaman. |

## Logika status pelayanan

- `< 5` laporan → **Pelayanan Lancar** (hijau)
- `5 – 10` laporan → **Pelayanan Sibuk** (oranye)
- `> 10` laporan → **Perlu Penambahan Petugas** (merah)
- Tombol **Laporan Selesai** tidak akan membuat angka di bawah nol.
- Tombol **Reset Harian** mengembalikan angka ke 0.

## Daftar tangkapan layar yang perlu diambil (sesuai Luaran)

- [ ] Tampilan awal (jumlah laporan = 0, status Pelayanan Lancar)
- [ ] Tampilan setelah beberapa kali menekan Laporan Masuk (status berubah
      jadi Pelayanan Sibuk, lalu Perlu Penambahan Petugas)
- [ ] Tampilan setelah menekan Laporan Selesai / Reset Harian
