import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import 'auth_state.dart';

// ============================================================
// AUTH CUBIT
// ============================================================
// Cubit = "otak" yang mengatur logika. UI hanya memanggil fungsi
// (login, register, logout), lalu Cubit memanggil API dan
// mengirim (emit) state baru ke UI.
//
//   UI --panggil fungsi--> Cubit --request--> ApiService --> Laravel
//   UI <--state baru------ Cubit <--hasil----
class AuthCubit extends Cubit<AuthState> {
  final ApiService api;

  // State awal: sedang mengecek apakah sudah pernah login
  AuthCubit(this.api) : super(const AuthState(isChecking: true));

  /// Dipanggil saat aplikasi dibuka.
  /// Jika ada token tersimpan, cek ke GET /auth/me.
  Future<void> checkLogin() async {
    final token = await api.getToken();
    if (token == null) {
      emit(const AuthState()); // belum login
      return;
    }
    try {
      final user = await api.getMe();
      emit(AuthState(user: user)); // masih login
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token sudah tidak berlaku
        await api.removeToken();
        emit(AuthState(message: e.message, isError: true));
      } else {
        emit(const AuthState()); // server mati, masuk sebagai tamu
      }
    }
  }

  /// Login. Mengembalikan true jika berhasil.
  Future<bool> login(String email, String password) async {
    emit(const AuthState(isLoading: true));
    try {
      final user = await api.login(email, password);
      emit(AuthState(user: user, message: 'Login berhasil. Halo, ${user.name}!'));
      return true;
    } on ApiException catch (e) {
      emit(AuthState(message: e.message, isError: true));
      return false;
    }
  }

  /// Registrasi akun baru. Mengembalikan true jika berhasil.
  Future<bool> register(String name, String email, String password) async {
    emit(const AuthState(isLoading: true));
    try {
      await api.register(name, email, password);
      emit(const AuthState(message: 'Registrasi berhasil, silakan login 🎉'));
      return true;
    } on ApiException catch (e) {
      emit(AuthState(message: e.message, isError: true));
      return false;
    }
  }

  /// Logout: hapus token di server dan di HP.
  Future<void> logout() async {
    emit(AuthState(user: state.user, isLoading: true));
    try {
      await api.logout();
    } on ApiException {
      // Abaikan: token di HP tetap sudah dihapus oleh ApiService
    }
    emit(const AuthState(message: 'Logout berhasil. Sampai jumpa 👋'));
  }
}
