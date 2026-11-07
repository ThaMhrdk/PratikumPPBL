import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/favorit_cubit.dart';
import 'cubit/pengajuan_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'navigation/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => FavoritCubit()),
        BlocProvider(create: (context) => PengajuanCubit()),
      ],
      child: const AplikasiNusantaraCerdas(),
    ),
  );
}

class AplikasiNusantaraCerdas extends StatelessWidget {
  const AplikasiNusantaraCerdas({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Nusantara Cerdas Mobile',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          initialRoute: AppRoutes.beranda,
          routes: AppRoutes.daftarRoute(),
          onGenerateRoute: AppRoutes.bentukRoute,
          onUnknownRoute: AppRoutes.routeTidakDikenal,
        );
      },
    );
  }
}
