import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/keranjang_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'helpers/hive_helper.dart';
import 'helpers/pengaturan_helper.dart';
import 'pages/halaman_favorit.dart';
import 'pages/halaman_keranjang.dart';
import 'pages/halaman_pengaturan.dart';
import 'pages/halaman_produk.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  final temaGelap = await PengaturanHelper.muatTemaGelap();
  runApp(KantinKampusApp(temaGelapAwal: temaGelap));
}

class KantinKampusApp extends StatelessWidget {
  final bool temaGelapAwal;

  const KantinKampusApp({super.key, this.temaGelapAwal = false});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => KeranjangCubit()),
        BlocProvider(
          create: (_) => ThemeCubit(
            initialMode: temaGelapAwal ? ThemeMode.dark : ThemeMode.light,
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Kantin Kampus',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const KerangkaUtama(),
          );
        },
      ),
    );
  }
}

class KerangkaUtama extends StatefulWidget {
  const KerangkaUtama({super.key});

  @override
  State<KerangkaUtama> createState() => _KerangkaUtamaState();
}

class _KerangkaUtamaState extends State<KerangkaUtama> {
  int _indeks = 0;
  final _halaman = const [
    HalamanProduk(),
    HalamanKeranjang(),
    HalamanPengaturan(),
    HalamanFavorit(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman[_indeks],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: (i) => setState(() => _indeks = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront), label: 'Produk'),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorit'),
        ],
      ),
    );
  }
}
