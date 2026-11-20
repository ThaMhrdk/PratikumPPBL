import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({ThemeMode initialMode = ThemeMode.system}) : super(initialMode);

  void toggle() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void setTemaGelap(bool gelap) {
    emit(gelap ? ThemeMode.dark : ThemeMode.light);
  }
}
