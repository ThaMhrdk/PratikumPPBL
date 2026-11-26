import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/post.dart';
import '../models/upload_file.dart';
import '../services/api_service.dart';
import 'post_state.dart';

// ============================================================
// POST CUBIT (CRUD ARTIKEL)
// ============================================================
// Pola setiap fungsi selalu sama:
//   1. emit state "loading"
//   2. panggil API (di dalam try)
//   3. berhasil -> emit state dengan data baru
//      gagal    -> emit state dengan pesan error (catch)
class PostCubit extends Cubit<PostState> {
  final ApiService api;

  PostCubit(this.api) : super(const PostState());

  /// READ: ambil semua artikel (GET /posts)
  Future<void> loadPosts() async {
    emit(PostState(posts: state.posts, isLoading: true));
    try {
      final posts = await api.getPosts();
      emit(PostState(posts: posts));
    } on ApiException catch (e) {
      emit(PostState(posts: state.posts, errorText: e.message));
    }
  }

  /// READ: ambil satu artikel terbaru (GET /posts/{id})
  Future<void> loadPostDetail(int id) async {
    try {
      final post = await api.getPost(id);
      emit(PostState(posts: _replacePost(post)));
    } on ApiException catch (e) {
      emit(PostState(posts: state.posts, message: e.message, isError: true));
    }
  }

  /// CREATE: tambah artikel (POST /posts). Mengembalikan true jika berhasil.
  /// [file] boleh null jika tidak ada lampiran.
  Future<bool> createPost(
    String title,
    String content, {
    UploadFile? file,
  }) async {
    emit(PostState(posts: state.posts, isSaving: true));
    try {
      final newPost = await api.createPost(title, content, file: file);
      emit(PostState(
        posts: [newPost, ...state.posts], // taruh paling atas
        message: 'Post berhasil diterbitkan 🎉',
      ));
      return true;
    } on ApiException catch (e) {
      emit(PostState(posts: state.posts, message: e.message, isError: true));
      return false;
    }
  }

  /// UPDATE: ubah artikel (PATCH /posts/{id}). Mengembalikan true jika berhasil.
  /// [file] = file pengganti, [removeFile] = true untuk menghapus lampiran.
  Future<bool> updatePost(
    int id,
    String title,
    String content, {
    UploadFile? file,
    bool removeFile = false,
  }) async {
    emit(PostState(posts: state.posts, isSaving: true));
    try {
      final updated = await api.updatePost(
        id,
        title,
        content,
        file: file,
        removeFile: removeFile,
      );
      emit(PostState(
        posts: _replacePost(updated),
        message: 'Post berhasil diubah ✏️',
      ));
      return true;
    } on ApiException catch (e) {
      // Contoh: 403 jika bukan pemilik artikel
      emit(PostState(posts: state.posts, message: e.message, isError: true));
      return false;
    }
  }

  /// DELETE: hapus artikel (DELETE /posts/{id}). Mengembalikan true jika berhasil.
  Future<bool> deletePost(int id) async {
    emit(PostState(posts: state.posts, isSaving: true));
    try {
      await api.deletePost(id);
      emit(PostState(
        posts: state.posts.where((p) => p.id != id).toList(),
        message: 'Post berhasil dihapus 🗑️',
      ));
      return true;
    } on ApiException catch (e) {
      emit(PostState(posts: state.posts, message: e.message, isError: true));
      return false;
    }
  }

  /// Mengganti satu post di dalam daftar dengan versi terbarunya.
  List<Post> _replacePost(Post newPost) {
    return state.posts.map((p) => p.id == newPost.id ? newPost : p).toList();
  }
}
