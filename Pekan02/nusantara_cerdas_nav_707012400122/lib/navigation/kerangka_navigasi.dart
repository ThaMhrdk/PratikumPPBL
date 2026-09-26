import 'package:flutter/material.dart';
import '../pages/halaman_beranda.dart';
import '../pages/halaman_layanan.dart';
import '../pages/halaman_warga.dart';
import 'app_routes.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _indeksTerpilih = 0;

  final List<Widget> _halaman = const [
    HalamanBeranda(),
    HalamanLayanan(),
    HalamanWarga(),
  ];

  final List<String> _judul = const ['Beranda', 'Layanan', 'Warga'];

  void _pilihTujuan(int indeks) {
    setState(() {
      _indeksTerpilih = indeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double lebar = MediaQuery.of(context).size.width;
    final bool layarLebar = lebar >= 600;

    return PopScope(
      // Berpindah tujuan (Beranda/Layanan/Warga) TIDAK menambah tumpukan
      // route, sehingga tombol kembali perangkat tidak boleh langsung
      // menutup aplikasi ketika pengguna belum berada pada tujuan Beranda.
      // canPop hanya true saat tujuan aktif adalah Beranda (indeks 0).
      canPop: _indeksTerpilih == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_indeksTerpilih != 0) {
          _pilihTujuan(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_judul[_indeksTerpilih])),
        drawer: _buatDrawer(),
        body: layarLebar ? _tataLetakLebar() : _halaman[_indeksTerpilih],
        // Bilah bawah disembunyikan pada layar lebar, digantikan NavigationRail.
        bottomNavigationBar: layarLebar ? null : _buatBilahBawah(),
      ),
    );
  }

  // NavigationBar Material 3, dipakai hanya pada layar sempit (< 600 px logis).
  Widget _buatBilahBawah() {
    return NavigationBar(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: _pilihTujuan,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon: Icon(Icons.miscellaneous_services_outlined),
          selectedIcon: Icon(Icons.miscellaneous_services),
          label: 'Layanan',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Warga',
        ),
      ],
    );
  }

  // Tata letak layar lebar (>= 600 px logis): NavigationRail di sisi kiri.
  Widget _tataLetakLebar() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _indeksTerpilih,
          onDestinationSelected: _pilihTujuan,
          extended: true,
          leading: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Icon(Icons.location_city, size: 32),
          ),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: Text('Beranda'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.miscellaneous_services_outlined),
              selectedIcon: Icon(Icons.miscellaneous_services),
              label: Text('Layanan'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: Text('Warga'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: _halaman[_indeksTerpilih]),
      ],
    );
  }

  // Panel samping: tiga tujuan utama yang sama + menu pendukung.
  Widget _buatDrawer() {
    return NavigationDrawer(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: (indeks) {
        _pilihTujuan(indeks);
        Navigator.pop(context); // drawer wajib ditutup dahulu
      },
      children: [
        const UserAccountsDrawerHeader(
          accountName: Text('Warga Kota Nusantara'),
          accountEmail: Text('Nusantara Cerdas Mobile'),
          currentAccountPicture: CircleAvatar(child: Icon(Icons.location_city)),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text('Layanan Utama'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Beranda'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.miscellaneous_services_outlined),
          selectedIcon: Icon(Icons.miscellaneous_services),
          label: Text('Layanan'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Warga'),
        ),
        const Divider(indent: 28, endIndent: 28),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 4, 16, 10),
          child: Text('Menu Pendukung'),
        ),
        // Menu pendukung dibuka melalui Navigator.pushNamed, dan drawer
        // ditutup terlebih dahulu sebelum halaman baru dibuka.
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Pengaturan Kota'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.pengaturanKota);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Tentang Aplikasi'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.tentangAplikasi);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Keluar'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.keluar);
          },
        ),
      ],
    );
  }
}
