// lib/navigation/kerangka_navigasi.dart (VERSI FINAL, tulis ulang seluruh berkas)
import 'package:flutter/material.dart';

import '../pages/halaman_beranda.dart';
import '../pages/halaman_jadwal.dart';
import '../pages/halaman_profil.dart';
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
    HalamanJadwal(),
    HalamanProfil(),
  ];
  final List<String> _judul = const ['Beranda', 'Jadwal', 'Profil'];
  void _pilihTujuan(int indeks) {
    setState(() {
      _indeksTerpilih = indeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ===== BARU (1) : membaca lebar layar untuk menentukan tata letak =====
    final double lebar = MediaQuery.of(context).size.width;
    final bool layarLebar = lebar >= 600;
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_indeksTerpilih])),
      drawer: _buatDrawer(),
      // ===== BARU (2) : isi halaman mengikuti lebar layar =====
      body: layarLebar ? _tataLetakLebar() : _halaman[_indeksTerpilih],
      // ===== BARU (3) : bilah bawah disembunyikan pada layar lebar =====
      bottomNavigationBar: layarLebar ? null : _buatBilahBawah(),
    );
  }

  // Bilah navigasi bawah, dipakai hanya pada layar sempit.
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
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Jadwal',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  // ===== BARU (4) : tata letak layar lebar, rail di kiri + isi di kanan =====
  Widget _tataLetakLebar() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _indeksTerpilih,
          onDestinationSelected: _pilihTujuan,
          extended: true,
          leading: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Icon(Icons.school, size: 32),
          ),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: Text('Beranda'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: Text('Jadwal'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: Text('Profil'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: _halaman[_indeksTerpilih]),
      ],
    );
  }

  // Drawer, isinya sama seperti subbagian sebelumnya.
  Widget _buatDrawer() {
    return NavigationDrawer(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: (indeks) {
        Navigator.pop(context);
      },
      children: [
        const UserAccountsDrawerHeader(
          accountName: Text('Muhammad Anantha Mahardika Ridwan'),
          accountEmail: Text('thamhrdk@gmail.com'),
          currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Beranda'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: Text('Jadwal'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profil'),
        ),
        const Divider(indent: 28, endIndent: 28),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Pengaturan'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.pengaturan);
          },
        ),
      ],
    );
  }
}
