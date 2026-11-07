import 'package:flutter/material.dart';
import '../pages/halaman_chat.dart';
import '../pages/halaman_layanan.dart';
import '../pages/halaman_peta.dart';
import '../pages/halaman_statistik.dart';
import '../pages/halaman_warga.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _indeksTerpilih = 0;

  final List<Widget> _halaman = const [
    HalamanLayanan(),
    HalamanWarga(),
    HalamanChat(),
    HalamanPeta(),
    HalamanStatistik(),
  ];

  final List<String> _judul = const [
    'Layanan Warga',
    'Tujuan Warga',
    'Tanya Petugas',
    'Lokasi Kantor',
    'Statistik Layanan',
  ];

  void _pilihTujuan(int indeks) {
    setState(() => _indeksTerpilih = indeks);
  }

  @override
  Widget build(BuildContext context) {
    final double lebar = MediaQuery.of(context).size.width;
    final bool layarLebar = lebar >= 600;

    return PopScope(
      canPop: _indeksTerpilih == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_indeksTerpilih != 0) {
          _pilihTujuan(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_judul[_indeksTerpilih]),
          centerTitle: false,
          elevation: 1,
        ),
        body: layarLebar ? _tataLetakLebar() : _halaman[_indeksTerpilih],
        bottomNavigationBar: layarLebar ? null : _buatBilahBawah(),
      ),
    );
  }

  // NavigationBar Material 3 untuk layar sempit (< 600 px)
  Widget _buatBilahBawah() {
    return NavigationBar(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: _pilihTujuan,
      destinations: const [
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
        NavigationDestination(
          icon: Icon(Icons.chat_outlined),
          selectedIcon: Icon(Icons.chat),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map),
          label: 'Peta',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: 'Statistik',
        ),
      ],
    );
  }

  // NavigationRail untuk layar lebar (>= 600 px)
  Widget _tataLetakLebar() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _indeksTerpilih,
          onDestinationSelected: _pilihTujuan,
          extended: true,
          leading: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Icon(Icons.location_city, size: 28, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Nusantara Cerdas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          destinations: const [
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
            NavigationRailDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(Icons.chat),
              label: Text('Chat'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: Text('Peta'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: Text('Statistik'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: _halaman[_indeksTerpilih]),
      ],
    );
  }
}
