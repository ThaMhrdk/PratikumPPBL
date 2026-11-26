// ============================================================
// KONFIGURASI ALAMAT API
// ============================================================
// Jalankan Laravel dengan perintah:
//   php artisan serve --host=0.0.0.0 --port=8000
//
// Ganti [ip] dengan IP laptop kamu (cek lewat perintah `ipconfig`),
// atau gunakan `10.0.2.2` jika menjalankan di Android Emulator.
// HP / emulator dan laptop harus berada di jaringan yang sama.
class ApiConfig {
  static const String ip = '192.168.137.1';
  static const String port = '8000';

  // Hasil akhirnya: http://192.168.137.1:8000/api
  static const String baseUrl = 'http://$ip:$port/api';
}
