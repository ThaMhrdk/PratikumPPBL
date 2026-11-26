import '../models/book.dart';

// ============================================================
// STATE BUKU SIPUSTAKA
// ============================================================
class BookState {
  final List<Book> books;
  final bool isLoading;
  final bool isSaving;
  final String? errorText;
  final String? message;
  final bool isError;

  const BookState({
    this.books = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.errorText,
    this.message,
    this.isError = false,
  });
}
