import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/book.dart';
import '../models/loan.dart';
import '../models/upload_file.dart';
import '../models/user.dart';

// ============================================================
// API SERVICE SIPUSTAKA
// ============================================================
// Mengelola komunikasi ke REST API Laravel SiPustaka:
// - Auth  : /auth/register, /auth/login, /auth/me, /auth/logout
// - Books : /books, /books/{id} (+ multipart cover upload & _method=PATCH)
// - Loans : /loans, /loans/{id}
class ApiException implements Exception {
  final String message;
  final int statusCode; // 0 = tidak bisa terhubung ke server

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class ApiService {
  static const String _tokenKey = 'sipustaka_token';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, String>> _headers({bool withToken = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (withToken) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Menangani seluruh respons HTTP beserta status error (401, 403, 404, 409, 422, 0).
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    http.Response response;
    try {
      response = await request().timeout(const Duration(seconds: 10));
    } catch (_) {
      throw ApiException(
        'Tidak bisa terhubung ke server.\n'
        'Pastikan Laravel SiPustaka berjalan di ${ApiConfig.baseUrl}',
        0,
      );
    }

    dynamic data;
    try {
      data = response.body.isEmpty ? null : jsonDecode(response.body);
    } catch (_) {
      data = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    String message = 'Terjadi kesalahan (kode ${response.statusCode})';
    if (response.statusCode == 401) {
      if (data is Map && data['message'] == 'Unauthenticated.') {
        message = 'Sesi login habis, silakan login ulang';
      } else if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else {
        message = 'Autentikasi gagal (401)';
      }
    } else if (response.statusCode == 422 &&
        data is Map &&
        data['errors'] is Map) {
      final errors = data['errors'] as Map;
      message = errors.values
          .map((e) => e is List && e.isNotEmpty ? e.first.toString() : '$e')
          .join('\n');
    } else if (data is Map && data['message'] != null) {
      message = data['message'].toString();
    } else if (response.statusCode == 403) {
      message = 'Anda tidak memiliki izin melakukan aksi ini (403)';
    } else if (response.statusCode == 404) {
      message = 'Data tidak ditemukan (404)';
    } else if (response.statusCode == 409) {
      message = 'Terjadi konflik data / email sudah terdaftar (409)';
    }
    throw ApiException(message, response.statusCode);
  }

  // ----------------------------------------------------------
  // AUTH
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
    await saveToken(data['access_token'].toString());
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<User> getMe() async {
    final data = await _send(() async => client.get(
          _url('/auth/me'),
          headers: await _headers(withToken: true),
        ));
    return User.fromJson(data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _send(() async => client.post(
            _url('/auth/logout'),
            headers: await _headers(withToken: true),
          ));
    } finally {
      await removeToken();
    }
  }

  // ----------------------------------------------------------
  // BOOKS (CRUD + MULTIPART COVER)
  // ----------------------------------------------------------
  Future<List<Book>> getBooks() async {
    final data = await _send(() async => client.get(
          _url('/books'),
          headers: await _headers(),
        ));
    return (data as List)
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Book> getBook(int id) async {
    final data = await _send(() async => client.get(
          _url('/books/$id'),
          headers: await _headers(),
        ));
    return Book.fromJson(data as Map<String, dynamic>);
  }

  Future<http.Response> _sendMultipartBook(
    String path,
    Map<String, String> fields,
    UploadFile? cover,
  ) async {
    final request = http.MultipartRequest('POST', _url(path));
    final headers = await _headers(withToken: true);
    headers.remove('Content-Type');
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    if (cover != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'cover',
        cover.bytes,
        filename: cover.name,
      ));
    }
    final streamed = await client.send(request);
    return http.Response.fromStream(streamed);
  }

  Future<Book> createBook({
    required String judul,
    required String penulis,
    required String penerbit,
    required int tahunTerbit,
    required int stok,
    UploadFile? cover,
  }) async {
    final data = await _send(() => _sendMultipartBook(
          '/books',
          {
            'judul': judul,
            'penulis': penulis,
            'penerbit': penerbit,
            'tahun_terbit': tahunTerbit.toString(),
            'stok': stok.toString(),
          },
          cover,
        ));
    return Book.fromJson(data as Map<String, dynamic>);
  }

  Future<Book> updateBook({
    required int id,
    required String judul,
    required String penulis,
    required String penerbit,
    required int tahunTerbit,
    required int stok,
    UploadFile? cover,
    bool removeCover = false,
  }) async {
    final data = await _send(() => _sendMultipartBook(
          '/books/$id',
          {
            '_method': 'PATCH',
            'judul': judul,
            'penulis': penulis,
            'penerbit': penerbit,
            'tahun_terbit': tahunTerbit.toString(),
            'stok': stok.toString(),
            if (removeCover) 'remove_cover': '1',
          },
          cover,
        ));
    return Book.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteBook(int id) async {
    await _send(() async => client.delete(
          _url('/books/$id'),
          headers: await _headers(withToken: true),
        ));
  }

  // ----------------------------------------------------------
  // LOANS (CRUD PEMINJAMAN)
  // ----------------------------------------------------------
  Future<List<Loan>> getLoans() async {
    final data = await _send(() async => client.get(
          _url('/loans'),
          headers: await _headers(withToken: true),
        ));
    return (data as List)
        .map((item) => Loan.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Loan> createLoan({
    required int bookId,
    required String tanggalPinjam,
    String? tanggalKembali,
  }) async {
    final payload = <String, dynamic>{
      'book_id': bookId,
      'tanggal_pinjam': tanggalPinjam,
      'status': 'Dipinjam',
      'tanggal_kembali': ?tanggalKembali,
    };
    final data = await _send(() async => client.post(
          _url('/loans'),
          headers: await _headers(withToken: true),
          body: jsonEncode(payload),
        ));
    return Loan.fromJson(data as Map<String, dynamic>);
  }

  Future<Loan> updateLoan({
    required int id,
    required String status,
    String? tanggalKembali,
  }) async {
    final payload = <String, dynamic>{
      'status': status,
      'tanggal_kembali': ?tanggalKembali,
    };
    final data = await _send(() async => client.patch(
          _url('/loans/$id'),
          headers: await _headers(withToken: true),
          body: jsonEncode(payload),
        ));
    return Loan.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteLoan(int id) async {
    await _send(() async => client.delete(
          _url('/loans/$id'),
          headers: await _headers(withToken: true),
        ));
  }
}
