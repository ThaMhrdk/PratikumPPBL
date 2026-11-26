import 'package:flutter/material.dart';

// ============================================================
// WARNA & TEMA APLIKASI SIPUSTAKA
// ============================================================
class AppColors {
  static const Color primary = Color(0xFF0D9488); // teal utama
  static const Color accent = Color(0xFF0F766E); // emerald gelap
  static const Color background = Color(0xFFF3F8F7); // latar bersih
  static const Color textDark = Color(0xFF132A2E);
  static const Color textGrey = Color(0xFF6B7F82);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> cardColors = [
    Color(0xFF0D9488),
    Color(0xFF0284C7),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF6366F1),
    Color(0xFFEC4899),
  ];
}

class AppTheme {
  static ThemeData get light {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.background,
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
