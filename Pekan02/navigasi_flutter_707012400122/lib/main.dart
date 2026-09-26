// lib/main.dart
import 'package:flutter/material.dart';

import 'navigation/app_routes.dart';

void main() {
  runApp(const AplikasiNavigasi());
}

class AplikasiNavigasi extends StatelessWidget {
  const AplikasiNavigasi({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Navigasi Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      // '/' terdaftar pada AppRoutes dan kini mengarah ke KerangkaNavigasi,
      // bukan lagi ke HalamanBeranda.
      initialRoute: AppRoutes.beranda,
      routes: AppRoutes.daftarRoute(),
      onGenerateRoute: AppRoutes.bentukRoute,
      onUnknownRoute: AppRoutes.routeTidakDikenal,
    );
  }
}
