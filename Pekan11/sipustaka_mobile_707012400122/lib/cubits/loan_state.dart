import '../models/loan.dart';

// ============================================================
// STATE PEMINJAMAN SIPUSTAKA
// ============================================================
class LoanState {
  final List<Loan> loans;
  final bool isLoading;
  final bool isSaving;
  final String? errorText;
  final String? message;
  final bool isError;

  const LoanState({
    this.loans = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.errorText,
    this.message,
    this.isError = false,
  });
}
