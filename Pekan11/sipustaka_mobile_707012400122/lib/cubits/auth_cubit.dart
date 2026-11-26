import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import 'auth_state.dart';

// ============================================================
// AUTH CUBIT SIPUSTAKA
// ============================================================
class AuthCubit extends Cubit<AuthState> {
  final ApiService api;

  AuthCubit(this.api) : super(const AuthState(isChecking: true));

  Future<void> checkLogin() async {
    emit(const AuthState(isChecking: true));
    final token = await api.getToken();
    if (token == null) {
      emit(const AuthState());
      return;
    }
    try {
      final user = await api.getMe();
      emit(AuthState(user: user));
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await api.removeToken();
        emit(AuthState(message: e.message, isError: true));
      } else {
        emit(const AuthState());
      }
    }
  }

  Future<bool> login(String email, String password) async {
    emit(const AuthState(isLoading: true));
    try {
      final user = await api.login(email, password);
      emit(AuthState(
        user: user,
        message: 'Login berhasil. Selamat datang, ${user.name}!',
      ));
      return true;
    } on ApiException catch (e) {
      emit(AuthState(message: e.message, isError: true));
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    emit(const AuthState(isLoading: true));
    try {
      await api.register(name, email, password);
      emit(const AuthState(
        message: 'Registrasi berhasil, silakan login terlebih dahulu',
      ));
      return true;
    } on ApiException catch (e) {
      emit(AuthState(message: e.message, isError: true));
      return false;
    }
  }

  Future<void> logout() async {
    emit(AuthState(user: state.user, isLoading: true));
    try {
      await api.logout();
      emit(const AuthState(message: 'Logout berhasil. Sampai jumpa'));
    } on ApiException catch (e) {
      emit(AuthState(message: e.message, isError: true));
    }
  }
}
