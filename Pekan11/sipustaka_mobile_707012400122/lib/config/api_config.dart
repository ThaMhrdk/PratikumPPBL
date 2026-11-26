// ============================================================
// KONFIGURASI ALAMAT API SIPUSTAKA
// ============================================================
// Jalankan backend Laravel SiPustaka (Pekan 10) dengan perintah:
//   php artisan serve --host=0.0.0.0 --port=8000
//
// Ganti [ip] dengan IPv4 laptop pada jaringan Wi-Fi yang sama,
// atau gunakan `10.0.2.2` saat menguji lewat Android Emulator.
class ApiConfig {
  static const String ip = '192.168.137.1';
  static const String port = '8000';

  // Hasil akhir: http://192.168.137.1:8000/api
  static const String baseUrl = 'http://$ip:$port/api';
}
