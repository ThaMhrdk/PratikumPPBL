import 'package:flutter/material.dart';
import '../pages/halaman_beranda.dart';
import '../pages/halaman_forum.dart';
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
    HalamanForum(),
    HalamanProfil(),
  ];

  final List<String> _judul = const ['Kutkatha', 'Forum', 'Profil'];

  void _pilihTujuan(int indeks) {
    setState(() {
      _indeksTerpilih = indeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Berpindah tujuan (Beranda/Forum/Profil) hanya mengganti isi
      // Scaffold, bukan menambah tumpukan route, sehingga tombol kembali
      // perangkat tidak boleh langsung menutup aplikasi begitu saja.
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
        body: _halaman[_indeksTerpilih],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _indeksTerpilih,
          onDestinationSelected: _pilihTujuan,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.forum_outlined),
              selectedIcon: Icon(Icons.forum),
              label: 'Forum',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
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
          accountName: Text('Warga Kutai Kartanegara'),
          accountEmail: Text('Kutkatha - Layanan Psikologis'),
          currentAccountPicture: CircleAvatar(child: Icon(Icons.self_improvement)),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text('Menu Utama'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Beranda'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.forum_outlined),
          selectedIcon: Icon(Icons.forum),
          label: Text('Forum'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profil'),
        ),
        const Divider(indent: 28, endIndent: 28),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 4, 16, 10),
          child: Text('Menu Pendukung'),
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Pengaturan'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.pengaturan);
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
