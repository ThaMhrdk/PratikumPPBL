import '../models/user.dart';

// ============================================================
// STATE AUTENTIKASI SIPUSTAKA
// ============================================================
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isChecking;
  final String? message;
  final bool isError;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isChecking = false,
    this.message,
    this.isError = false,
  });

  bool get isLoggedIn => user != null;
}
