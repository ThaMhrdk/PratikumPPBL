import '../models/post.dart';

// ============================================================
// STATE POST
// ============================================================
class PostState {
  final List<Post> posts; // daftar artikel
  final bool isLoading; // sedang mengambil daftar artikel
  final bool isSaving; // sedang tambah / ubah / hapus artikel
  final String? errorText; // error saat memuat daftar (tampil di layar)
  final String? message; // pesan untuk SnackBar
  final bool isError; // true = pesan error (merah)

  const PostState({
    this.posts = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.errorText,
    this.message,
    this.isError = false,
  });
}
