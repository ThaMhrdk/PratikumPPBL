import 'package:flutter/material.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(const AplikasiKutkatha());
}

class AplikasiKutkatha extends StatelessWidget {
  const AplikasiKutkatha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kutkatha - Kerangka Desain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.beranda,
      routes: AppRoutes.daftarRoute(),
      onGenerateRoute: AppRoutes.bentukRoute,
      onUnknownRoute: AppRoutes.routeTidakDikenal,
    );
  }
}
