import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/booking_cubit.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(
    // BlocProvider diletakkan DI ATAS MaterialApp agar BookingCubit dapat
    // diakses oleh seluruh route, termasuk halaman penuh yang dibuka melalui
    // Navigator.pushNamed (Daftar Psikolog dan Rincian Psikolog), sehingga
    // tidak muncul galat "provider tidak ditemukan".
    BlocProvider(
      create: (context) => BookingCubit(),
      child: const AplikasiKutkatha(),
    ),
  );
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
