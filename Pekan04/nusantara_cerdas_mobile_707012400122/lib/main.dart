import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/pengajuan_model.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(
    // Membungkus seluruh aplikasi dengan ChangeNotifierProvider agar PengajuanModel
    // dapat diakses secara global oleh seluruh halaman dan navigasi.
    ChangeNotifierProvider(
      create: (_) => PengajuanModel(),
      child: const AplikasiNusantaraCerdasMobile(),
    ),
  );
}

class AplikasiNusantaraCerdasMobile extends StatelessWidget {
  const AplikasiNusantaraCerdasMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusantara Cerdas Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
      ),
      initialRoute: AppRoutes.beranda,
      routes: AppRoutes.daftarRoute(),
      onGenerateRoute: AppRoutes.bentukRoute,
      onUnknownRoute: AppRoutes.routeTidakDikenal,
    );
  }
}
