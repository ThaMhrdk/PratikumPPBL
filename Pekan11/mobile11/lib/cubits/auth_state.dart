import '../models/user.dart';

// ============================================================
// STATE AUTENTIKASI
// ============================================================
// State = "kondisi" yang sedang terjadi. Setiap kali kondisi berubah,
// Cubit membuat AuthState baru lalu memanggil emit(...),
// kemudian tampilan (UI) otomatis diperbarui.
class AuthState {
  final User? user; // null = belum login
  final bool isLoading; // sedang proses login / register / logout
  final bool isChecking; // sedang cek token saat aplikasi dibuka
  final String? message; // pesan untuk SnackBar
  final bool isError; // true = pesan error (merah)

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isChecking = false,
    this.message,
    this.isError = false,
  });

  bool get isLoggedIn => user != null;
}
