import 'book.dart';
import 'user.dart';

// ============================================================
// MODEL PEMINJAMAN (TABEL loans LARAVEL)
// ============================================================
class Loan {
  final int id;
  final int bookId;
  final int userId;
  final String tanggalPinjam;
  final String? tanggalKembali;
  final String status;
  final Book? book;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Loan({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.tanggalPinjam,
    this.tanggalKembali,
    required this.status,
    this.book,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: int.parse(json['id'].toString()),
      bookId: int.tryParse(json['book_id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tanggalPinjam: json['tanggal_pinjam']?.toString() ?? '',
      tanggalKembali: json['tanggal_kembali']?.toString(),
      status: json['status']?.toString() ?? 'Dipinjam',
      book: json['book'] is Map<String, dynamic>
          ? Book.fromJson(json['book'] as Map<String, dynamic>)
          : null,
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '')
          ?.toLocal(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '')
          ?.toLocal(),
    );
  }

  bool get isReturned => status.toLowerCase() == 'dikembalikan';
}
