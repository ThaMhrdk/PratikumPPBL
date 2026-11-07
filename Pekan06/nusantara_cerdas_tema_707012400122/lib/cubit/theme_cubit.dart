import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ThemeCubit mengelola state perpindahan tema antara mode terang (ThemeMode.light)
/// dan mode gelap (ThemeMode.dark).
///
/// Menggunakan flutter_bloc (Cubit) agar perpindahan tema dapat disiarkan
/// ke seluruh aplikasi (MaterialApp) tanpa memuat ulang aplikasi.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  /// Beralih antara mode gelap dan mode terang
  void toggle() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  /// Menetapkan mode tema secara eksplisit
  void setMode(ThemeMode mode) {
    emit(mode);
  }
}
