import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/app_theme.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/auth_state.dart';
import 'cubits/post_cubit.dart';
import 'cubits/post_state.dart';
import 'pages/home_page.dart';
import 'services/api_service.dart';
import 'utils/helpers.dart';

void main() {
  runApp(MyApp(api: ApiService()));
}

class MyApp extends StatelessWidget {
  final ApiService api;

  const MyApp({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    // 1. Daftarkan Cubit agar bisa dipakai di SEMUA halaman
    return MultiBlocProvider(
      providers: [
        // ..checkLogin() langsung dipanggil saat Cubit dibuat
        BlocProvider(create: (_) => AuthCubit(api)..checkLogin()),
        BlocProvider(create: (_) => PostCubit(api)..loadPosts()),
      ],
      // 2. Dengarkan pesan dari Cubit, lalu tampilkan sebagai SnackBar
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) => current.message != null,
            listener: (context, state) {
              showMessage(state.message!, isError: state.isError);
            },
          ),
          BlocListener<PostCubit, PostState>(
            listenWhen: (previous, current) => current.message != null,
            listener: (context, state) {
              showMessage(state.message!, isError: state.isError);
            },
          ),
        ],
        // 3. Aplikasi
        child: MaterialApp(
          title: 'Blog Post',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: messengerKey,
          theme: AppTheme.light,
          home: const HomePage(),
        ),
      ),
    );
  }
}
