import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/pantauan_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'helpers/hive_helper.dart';
import 'helpers/pengaturan_helper.dart';
import 'pages/halaman_pantauan.dart';
import 'pages/halaman_pengaturan.dart';
import 'pages/halaman_riwayat.dart';
import 'pages/halaman_sensor.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  final temaGelap = await PengaturanHelper.muatTemaGelap();
  await PengaturanHelper.muatAmbangBatas();
  runApp(AiotPeringatanDiniApp(temaGelapAwal: temaGelap));
}

class AiotPeringatanDiniApp extends StatelessWidget {
  final bool temaGelapAwal;

  const AiotPeringatanDiniApp({super.key, this.temaGelapAwal = false});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PantauanCubit()),
        BlocProvider(
          create: (_) => ThemeCubit(
            initialMode: temaGelapAwal ? ThemeMode.dark : ThemeMode.light,
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'AIoT Peringatan Dini Bencana',
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
    HalamanSensor(),
    HalamanPantauan(),
    HalamanRiwayat(),
    HalamanPengaturan(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman[_indeks],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: (i) => setState(() => _indeks = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sensors),
            label: 'Sensor',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_heart_outlined),
            label: 'Pantauan',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
