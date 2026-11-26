import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../models/upload_file.dart';
import '../services/api_service.dart';
import 'book_state.dart';

// ============================================================
// BOOK CUBIT (CRUD KATALOG BUKU)
// ============================================================
class BookCubit extends Cubit<BookState> {
  final ApiService api;

  BookCubit(this.api) : super(const BookState());

  Future<void> loadBooks() async {
    emit(BookState(books: state.books, isLoading: true));
    try {
      final books = await api.getBooks();
      emit(BookState(books: books));
    } on ApiException catch (e) {
      emit(BookState(books: state.books, errorText: e.message));
    }
  }

  Future<void> loadBookDetail(int id) async {
    emit(BookState(books: state.books, isLoading: true));
    try {
      final book = await api.getBook(id);
      emit(BookState(books: _replaceBook(book)));
    } on ApiException catch (e) {
      emit(BookState(books: state.books, message: e.message, isError: true));
    }
  }

  Future<bool> createBook({
    required String judul,
    required String penulis,
    required String penerbit,
    required int tahunTerbit,
    required int stok,
    UploadFile? cover,
  }) async {
    emit(BookState(books: state.books, isSaving: true));
    try {
      final newBook = await api.createBook(
        judul: judul,
        penulis: penulis,
        penerbit: penerbit,
        tahunTerbit: tahunTerbit,
        stok: stok,
        cover: cover,
      );
      emit(BookState(
        books: [newBook, ...state.books],
        message: 'Buku "${newBook.judul}" berhasil ditambahkan',
      ));
      return true;
    } on ApiException catch (e) {
      emit(BookState(books: state.books, message: e.message, isError: true));
      return false;
    }
  }

  Future<bool> updateBook({
    required int id,
    required String judul,
    required String penulis,
    required String penerbit,
    required int tahunTerbit,
    required int stok,
    UploadFile? cover,
    bool removeCover = false,
  }) async {
    emit(BookState(books: state.books, isSaving: true));
    try {
      final updated = await api.updateBook(
        id: id,
        judul: judul,
        penulis: penulis,
        penerbit: penerbit,
        tahunTerbit: tahunTerbit,
        stok: stok,
        cover: cover,
        removeCover: removeCover,
      );
      emit(BookState(
        books: _replaceBook(updated),
        message: 'Data buku "${updated.judul}" berhasil diperbarui',
      ));
      return true;
    } on ApiException catch (e) {
      emit(BookState(books: state.books, message: e.message, isError: true));
      return false;
    }
  }

  Future<bool> deleteBook(int id) async {
    emit(BookState(books: state.books, isSaving: true));
    try {
      await api.deleteBook(id);
      emit(BookState(
        books: state.books.where((b) => b.id != id).toList(),
        message: 'Buku berhasil dihapus',
      ));
      return true;
    } on ApiException catch (e) {
      emit(BookState(books: state.books, message: e.message, isError: true));
      return false;
    }
  }

  List<Book> _replaceBook(Book updated) {
    final exists = state.books.any((b) => b.id == updated.id);
    if (!exists) return [updated, ...state.books];
    return state.books.map((b) => b.id == updated.id ? updated : b).toList();
  }
}
