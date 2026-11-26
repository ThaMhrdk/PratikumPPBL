import '../utils/helpers.dart';

// ============================================================
// MODEL POST (ARTIKEL)
// ============================================================
// Contoh JSON dari API (tabel posts di Laravel):
// {
//   "id": 1,
//   "user_id": 2,
//   "title": "Belajar Laravel",
//   "content": "Isi artikel...",
//   "file_name": "materi.pdf",                              <- boleh null
//   "file_url": "http://192.168.0.111:8000/api/posts/1/file", <- boleh null
//   "created_at": "2026-11-14T10:00:00.000000Z",
//   "updated_at": "2026-11-14T10:00:00.000000Z"
// }
class Post {
  final int id;
  final int? userId; // pemilik artikel
  final String title;
  final String content;
  final String? fileName; // nama file lampiran
  final String? fileUrl; // alamat untuk membuka file lampiran
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.fileName,
    this.fileUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: int.parse(json['id'].toString()),
      userId: int.tryParse(json['user_id'].toString()),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      fileName: json['file_name'],
      fileUrl: json['file_url'],
      // tryParse: kalau gagal hasilnya null (tidak error)
      createdAt: DateTime.tryParse(json['created_at'] ?? '')?.toLocal(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '')?.toLocal(),
    );
  }

  /// Apakah artikel punya file lampiran?
  bool get hasFile => fileUrl != null;

  /// Apakah lampirannya berupa gambar?
  bool get hasImage => hasFile && isImageFile(fileName ?? '');

  /// URL gambar + versi, agar gambar lama tidak tertahan di cache
  /// setelah file diganti.
  String get imageUrl => '$fileUrl?v=${updatedAt?.millisecondsSinceEpoch}';
}
