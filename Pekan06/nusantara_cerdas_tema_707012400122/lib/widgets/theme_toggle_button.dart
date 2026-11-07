import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/theme_cubit.dart';

/// ThemeToggleButton adalah Custom Reusable Widget berupa tombol ikon di AppBar
/// untuk berpindah secara cepat antara Mode Terang dan Mode Gelap.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    final isDark = mode == ThemeMode.dark;

    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      tooltip: isDark ? 'Beralih ke Mode Terang' : 'Beralih ke Mode Gelap',
      onPressed: () => context.read<ThemeCubit>().toggle(),
    );
  }
}
