import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/post.dart';
import '../models/upload_file.dart';
import '../models/user.dart';

// ============================================================
// API SERVICE
// ============================================================
// Semua komunikasi dengan REST API Laravel ada di file ini.
//
// | Method | Endpoint             | Butuh token? |
// |--------|----------------------|--------------|
// | POST   | /auth/register       | Tidak        |
// | POST   | /auth/login          | Tidak        |
// | GET    | /auth/me             | Ya           |
// | POST   | /auth/logout         | Ya           |
// | GET    | /posts               | Tidak        |
// | GET    | /posts/{id}          | Tidak        |
// | POST   | /posts               | Ya           |
// | PATCH  | /posts/{id}          | Ya           |
// | DELETE | /posts/{id}          | Ya           |
// | GET    | /posts/{id}/file     | Tidak        |  <- buka file lampiran
//
// Tambah & ubah post dikirim sebagai multipart/form-data
// (bukan JSON) agar bisa sekaligus membawa file.

/// Error yang dikirim ketika request ke API gagal.
class ApiException implements Exception {
  final String message;
  final int statusCode; // 0 artinya tidak bisa terhubung ke server

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();

  // ----------------------------------------------------------
  // 1. MENYIMPAN TOKEN (agar tetap login walau aplikasi ditutup)
  // ----------------------------------------------------------
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ----------------------------------------------------------
  // 2. FUNGSI BANTUAN
  // ----------------------------------------------------------
  /// Membuat URL lengkap, contoh: '/posts' -> http://IP:8000/api/posts
  Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  /// Header yang dikirim di setiap request.
  /// Jika [withToken] true, token ditambahkan: `Authorization: Bearer <token>`
  Future<Map<String, String>> _headers({bool withToken = false}) async {
    final headers = {
      'Accept': 'application/json', // agar Laravel membalas dalam JSON
      'Content-Type': 'application/json',
    };
    if (withToken) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Mengirim request lalu memeriksa hasilnya.
  /// - Status 200-299  -> kembalikan data JSON
  /// - Status lainnya  -> lempar ApiException berisi pesan error
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    http.Response response;
    try {
      response = await request().timeout(const Duration(seconds: 10));
    } catch (e) {
      throw ApiException(
        'Tidak bisa terhubung ke server.\n'
        'Pastikan Laravel berjalan di ${ApiConfig.baseUrl}',
        0,
      );
    }

    // Ubah teks JSON menjadi Map / List
    dynamic data;
    try {
      data = response.body.isEmpty ? null : jsonDecode(response.body);
    } catch (_) {
      data = null;
    }

    // Berhasil
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    // Gagal: ambil pesan error dari Laravel
    String message = 'Terjadi kesalahan (kode ${response.statusCode})';
    if (data is Map && data['message'] == 'Unauthenticated.') {
      // 401 dari middleware auth:sanctum (token salah / sudah logout)
      message = 'Sesi login habis, silakan login ulang';
    } else if (data is Map && data['errors'] is Map) {
      // Error validasi 422, contoh: {"errors": {"title": ["..."]}}
      final errors = data['errors'] as Map;
      message = errors.values.map((e) => (e as List).first).join('\n');
    } else if (data is Map && data['message'] != null) {
      message = data['message'].toString();
    }
    throw ApiException(message, response.statusCode);
  }

  // ----------------------------------------------------------
  // 3. AUTENTIKASI
  // ----------------------------------------------------------
  Future<void> register(String name, String email, String password) async {
    await _send(() async => client.post(
          _url('/auth/register'),
          headers: await _headers(),
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
          }),
        ));
  }

  Future<User> login(String email, String password) async {
    final data = await _send(() async => client.post(
          _url('/auth/login'),
          headers: await _headers(),
          body: jsonEncode({'email': email, 'password': password}),
        ));
    // Simpan token dari Laravel Sanctum
    await saveToken(data['access_token']);
    return User.fromJson(data['user']);
  }

  Future<User> getMe() async {
    final data = await _send(() async => client.get(
          _url('/auth/me'),
          headers: await _headers(withToken: true),
        ));
    return User.fromJson(data);
  }

  Future<void> logout() async {
    try {
      await _send(() async => client.post(
            _url('/auth/logout'),
            headers: await _headers(withToken: true),
          ));
    } finally {
      // Token di HP tetap dihapus walaupun request gagal
      await removeToken();
    }
  }

  // ----------------------------------------------------------
  // 4. CRUD POST
  // ----------------------------------------------------------
  Future<List<Post>> getPosts() async {
    final data = await _send(() async => client.get(
          _url('/posts'),
          headers: await _headers(),
        ));
    // data berupa List, ubah setiap item menjadi objek Post
    return (data as List).map((item) => Post.fromJson(item)).toList();
  }

  Future<Post> getPost(int id) async {
    final data = await _send(() async => client.get(
          _url('/posts/$id'),
          headers: await _headers(),
        ));
    return Post.fromJson(data);
  }

  /// Mengirim form + file (multipart/form-data).
  /// Dipakai untuk tambah dan ubah post.
  Future<http.Response> _sendMultipart(
    String path,
    Map<String, String> fields,
    UploadFile? file,
  ) async {
    final request = http.MultipartRequest('POST', _url(path));
    final headers = await _headers(withToken: true);
    headers.remove('Content-Type'); // diisi otomatis: multipart/form-data
    request.headers.addAll(headers);
    request.fields.addAll(fields); // data teks: title, content, dll.
    if (file != null) {
      // 'file' harus sama dengan nama field di Laravel: $request->file('file')
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.bytes,
        filename: file.name,
      ));
    }
    final streamed = await client.send(request);
    return http.Response.fromStream(streamed);
  }

  /// CREATE: POST /posts (file boleh null)
  Future<Post> createPost(
    String title,
    String content, {
    UploadFile? file,
  }) async {
    final data = await _send(() => _sendMultipart(
          '/posts',
          {'title': title, 'content': content},
          file,
        ));
    return Post.fromJson(data);
  }

  /// UPDATE: PATCH /posts/{id}
  ///
  /// PHP tidak bisa membaca file dari request PATCH, jadi kita kirim
  /// POST dengan field `_method=PATCH` (method spoofing Laravel).
  /// - [file]       : file baru untuk mengganti lampiran lama
  /// - [removeFile] : true untuk menghapus lampiran
  Future<Post> updatePost(
    int id,
    String title,
    String content, {
    UploadFile? file,
    bool removeFile = false,
  }) async {
    final data = await _send(() => _sendMultipart(
          '/posts/$id',
          {
            '_method': 'PATCH',
            'title': title,
            'content': content,
            if (removeFile) 'remove_file': '1',
          },
          file,
        ));
    return Post.fromJson(data);
  }

  Future<void> deletePost(int id) async {
    await _send(() async => client.delete(
          _url('/posts/$id'),
          headers: await _headers(withToken: true),
        ));
  }
}
