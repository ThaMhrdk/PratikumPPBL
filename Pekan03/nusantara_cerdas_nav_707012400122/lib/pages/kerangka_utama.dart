// lib/pages/kerangka_utama.dart
import 'package:flutter/material.dart';

import '../widgets/ikon_warga_badge.dart';
import 'halaman_beranda.dart';
import 'halaman_layanan.dart';
import 'halaman_warga.dart';

class KerangkaUtama extends StatefulWidget {
  const KerangkaUtama({super.key});

  @override
  State<KerangkaUtama> createState() => _KerangkaUtamaState();
}

class _KerangkaUtamaState extends State<KerangkaUtama> {
  // State lokal: indeks tujuan hanya penting bagi widget ini -> setState().
  int _indeks = 0;

  static const _judul = ['Beranda', 'Layanan', 'Warga'];
  static const _halaman = [HalamanBeranda(), HalamanLayanan(), HalamanWarga()];
  static const _ruteDrawer = ['/tentang', '/bantuan'];

  void _pilihTujuan(int nilaiBaru) {
    setState(() {
      _indeks = nilaiBaru;
    });
  }

  Widget _buatDrawer() {
    return NavigationDrawer(
      selectedIndex: null,
      onDestinationSelected: (indeks) {
        Navigator.pop(context); // tutup drawer
        Navigator.pushNamed(context, _ruteDrawer[indeks]);
      },
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Nusantara Cerdas Mobile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.info_outline),
          label: Text('Tentang Aplikasi'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.help_outline),
          label: Text('Bantuan'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Catatan: build() ini TIDAK membaca Provider, sehingga kerangka navigasi
    // tidak ikut dibangun ulang ketika favorit atau pengajuan berubah.
    final layarLebar = MediaQuery.sizeOf(context).width >= 720;

    final isi = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: IndexedStack(
          index: _indeks,
          sizing: StackFit.expand,
          children: _halaman,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(_judul[_indeks])),
      drawer: _buatDrawer(),
      body: layarLebar
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _indeks,
                  onDestinationSelected: _pilihTujuan,
                  labelType: NavigationRailLabelType.all,
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
                      icon: IkonWargaBadge(terpilih: false),
                      selectedIcon: IkonWargaBadge(terpilih: true),
                      label: Text('Warga'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: isi),
              ],
            )
          : isi,
      bottomNavigationBar: layarLebar
          ? null
          : NavigationBar(
              selectedIndex: _indeks,
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
                  icon: IkonWargaBadge(terpilih: false),
                  selectedIcon: IkonWargaBadge(terpilih: true),
                  label: 'Warga',
                ),
              ],
            ),
    );
  }
}
