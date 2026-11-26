// ============================================================
// MODEL BUKU (TABEL books LARAVEL)
// ============================================================
class Book {
  final int id;
  final String judul;
  final String penulis;
  final String penerbit;
  final int tahunTerbit;
  final int stok;
  final String? coverName;
  final String? coverUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Book({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.penerbit,
    required this.tahunTerbit,
    required this.stok,
    this.coverName,
    this.coverUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.parse(json['id'].toString()),
      judul: json['judul']?.toString() ?? '',
      penulis: json['penulis']?.toString() ?? '',
      penerbit: json['penerbit']?.toString() ?? '',
      tahunTerbit: int.tryParse(json['tahun_terbit'].toString()) ?? 0,
      stok: int.tryParse(json['stok'].toString()) ?? 0,
      coverName: json['cover_name']?.toString(),
      coverUrl: json['cover_url']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '')
          ?.toLocal(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '')
          ?.toLocal(),
    );
  }

  /// Apakah buku memiliki URL sampul dari server?
  bool get hasCover => coverUrl != null && coverUrl!.isNotEmpty;

  /// URL sampul dengan penanda versi agar gambar terbaru tidak tertahan cache.
  String get coverImageUrl =>
      '$coverUrl?v=${updatedAt?.millisecondsSinceEpoch ?? 0}';
}
