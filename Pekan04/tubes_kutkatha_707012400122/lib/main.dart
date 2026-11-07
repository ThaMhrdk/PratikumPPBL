import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/konsultasi_model.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(
    // Membungkus seluruh aplikasi dengan ChangeNotifierProvider agar KonsultasiModel
    // dapat diakses secara terpusat oleh seluruh widget dan halaman aplikasi Kutkatha.
    ChangeNotifierProvider(
      create: (_) => KonsultasiModel(),
      child: const AplikasiKutkathaMobile(),
    ),
  );
}

class AplikasiKutkathaMobile extends StatelessWidget {
  const AplikasiKutkathaMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kutkatha - Konsultasi Psikologi Kukar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade700,
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
