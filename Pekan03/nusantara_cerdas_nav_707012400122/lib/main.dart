// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/favorit_model.dart';
import 'models/layanan.dart';
import 'models/pengajuan_model.dart';
import 'pages/halaman_info.dart';
import 'pages/halaman_rincian_layanan.dart';
import 'pages/kerangka_utama.dart';

void main() {
  runApp(
    // MultiProvider berada DI ATAS MaterialApp, sehingga semua named route
    // (termasuk '/rincian' yang dibuka lewat Navigator) tetap berada di bawah
    // provider yang sama dan tidak memicu ProviderNotFoundException.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritModel()),
        ChangeNotifierProvider(create: (context) => PengajuanModel()),
      ],
      child: const AplikasiNusantaraCerdas(),
    ),
  );
}

class AplikasiNusantaraCerdas extends StatelessWidget {
  const AplikasiNusantaraCerdas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nusantara Cerdas Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const KerangkaUtama(),
        '/rincian': (context) {
          final layanan =
              ModalRoute.of(context)!.settings.arguments as Layanan;
          return HalamanRincianLayanan(layanan: layanan);
        },
        '/tentang': (context) => const HalamanTentang(),
        '/bantuan': (context) => const HalamanBantuan(),
      },
    );
  }
}
