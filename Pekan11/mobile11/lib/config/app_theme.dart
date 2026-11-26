import 'package:flutter/material.dart';

// ============================================================
// WARNA & TEMA APLIKASI
// ============================================================
// Semua warna dikumpulkan di sini, jadi kalau ingin mengganti
// warna aplikasi cukup ubah file ini saja.
class AppColors {
  static const Color primary = Color(0xFF6C63FF); // ungu
  static const Color accent = Color(0xFFB462F5); // ungu-pink
  static const Color background = Color(0xFFF5F6FB); // abu sangat muda
  static const Color textDark = Color(0xFF1F2340);
  static const Color textGrey = Color(0xFF8A8FA8);
  static const Color success = Color(0xFF00B894); // hijau
  static const Color danger = Color(0xFFFF6B6B); // merah

  // Gradasi warna utama (dipakai di header & tombol)
  static const LinearGradient mainGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Warna-warni untuk ikon kartu post
  static const List<Color> cardColors = [
    Color(0xFF6C63FF),
    Color(0xFFFF6B6B),
    Color(0xFF00B894),
    Color(0xFFFDA43C),
    Color(0xFF0984E3),
    Color(0xFFE84393),
  ];
}

class AppTheme {
  static ThemeData get light {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.background,
      // Gaya semua TextField / TextFormField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
      ),
    );
  }
}
