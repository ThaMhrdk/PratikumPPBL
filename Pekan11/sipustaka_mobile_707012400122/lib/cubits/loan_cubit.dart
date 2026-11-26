import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/loan.dart';
import '../services/api_service.dart';
import '../utils/helpers.dart';
import 'loan_state.dart';

// ============================================================
// LOAN CUBIT (CRUD PEMINJAMAN BUKU)
// ============================================================
class LoanCubit extends Cubit<LoanState> {
  final ApiService api;

  LoanCubit(this.api) : super(const LoanState());

  Future<void> loadLoans() async {
    emit(LoanState(loans: state.loans, isLoading: true));
    try {
      final loans = await api.getLoans();
      emit(LoanState(loans: loans));
    } on ApiException catch (e) {
      emit(LoanState(loans: state.loans, errorText: e.message));
    }
  }

  Future<bool> createLoan({
    required int bookId,
    required String tanggalPinjam,
    String? tanggalKembali,
  }) async {
    emit(LoanState(loans: state.loans, isSaving: true));
    try {
      final created = await api.createLoan(
        bookId: bookId,
        tanggalPinjam: tanggalPinjam,
        tanggalKembali: tanggalKembali,
      );
      emit(LoanState(
        loans: [created, ...state.loans],
        message: 'Peminjaman buku berhasil dicatat',
      ));
      return true;
    } on ApiException catch (e) {
      emit(LoanState(loans: state.loans, message: e.message, isError: true));
      return false;
    }
  }

  Future<bool> markReturned(Loan loan) async {
    emit(LoanState(loans: state.loans, isSaving: true));
    try {
      final updated = await api.updateLoan(
        id: loan.id,
        status: 'Dikembalikan',
        tanggalKembali: loan.tanggalKembali ?? formatIsoDate(DateTime.now()),
      );
      emit(LoanState(
        loans: state.loans.map((l) => l.id == updated.id ? updated : l).toList(),
        message: 'Status peminjaman diubah menjadi Dikembalikan',
      ));
      return true;
    } on ApiException catch (e) {
      emit(LoanState(loans: state.loans, message: e.message, isError: true));
      return false;
    }
  }

  Future<bool> deleteLoan(int id) async {
    emit(LoanState(loans: state.loans, isSaving: true));
    try {
      await api.deleteLoan(id);
      emit(LoanState(
        loans: state.loans.where((l) => l.id != id).toList(),
        message: 'Data peminjaman berhasil dihapus',
      ));
      return true;
    } on ApiException catch (e) {
      emit(LoanState(loans: state.loans, message: e.message, isError: true));
      return false;
    }
  }

  void clearLoans() {
    emit(const LoanState());
  }
}
