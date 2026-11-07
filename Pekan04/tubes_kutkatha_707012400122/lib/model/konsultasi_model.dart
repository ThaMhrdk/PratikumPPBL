import 'package:flutter/foundation.dart';

class SesiKonsultasi {
  final String id;
  final String namaPasien;
  final String email;
  final String namaPsikolog;
  final String kategori;
  final String mode; // 'Online (Video Call)' atau 'Tatap Muka (Klinik)'
  final String sesi; // 'Pagi', 'Siang', 'Sore'
  final DateTime tanggal;
  bool selesai;
  final String keluhan;

  SesiKonsultasi({
    required this.id,
    required this.namaPasien,
    required this.email,
    required this.namaPsikolog,
    required this.kategori,
    required this.mode,
    required this.sesi,
    required this.tanggal,
    this.selesai = false,
    this.keluhan = '',
  });
}

class KonsultasiModel extends ChangeNotifier {
  final List<SesiKonsultasi> _daftar = [
    SesiKonsultasi(
      id: 'KTH-101',
      namaPasien: 'Muhammad Anantha Mahardika Ridwan',
      email: 'anantha@kutkatha.id',
      namaPsikolog: 'Muhammad Anantha M. R., M.Psi., Psikolog',
      kategori: 'Kecemasan',
      mode: 'Online (Video Call)',
      sesi: 'Pagi',
      tanggal: DateTime.now().subtract(const Duration(days: 3)),
      selesai: true,
      keluhan: 'Konsultasi penanganan kecemasan pra-presentasi akademik.',
    ),
    SesiKonsultasi(
      id: 'KTH-102',
      namaPasien: 'Muhammad Anantha Mahardika Ridwan',
      email: 'anantha@kutkatha.id',
      namaPsikolog: 'Hani Nadia Hendra, M.Psi., Psikolog',
      kategori: 'Stres Kuliah',
      mode: 'Tatap Muka (Klinik)',
      sesi: 'Siang',
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
      selesai: false,
      keluhan: 'Manajemen waktu dan beban tugas akhir perkuliahan.',
    ),
    SesiKonsultasi(
      id: 'KTH-103',
      namaPasien: 'Muhammad Anantha Mahardika Ridwan',
      email: 'anantha@kutkatha.id',
      namaPsikolog: 'Mumpuni Nur Idzati, M.Psi., Psikolog',
      kategori: 'Keluarga',
      mode: 'Online (Video Call)',
      sesi: 'Sore',
      tanggal: DateTime.now(),
      selesai: false,
      keluhan: 'Konseling komunikasi keluarga dan resolusi konflik.',
    ),
  ];

  List<SesiKonsultasi> get daftar => List.unmodifiable(_daftar);

  int get totalKonsultasi => _daftar.length;
  int get totalSelesai => _daftar.where((s) => s.selesai).length;
  int get totalAktif => _daftar.where((s) => !s.selesai).length;

  bool sudahDibooking(String namaPsikolog) {
    return _daftar.any((s) => s.namaPsikolog == namaPsikolog && !s.selesai);
  }

  void tambah(SesiKonsultasi sesi) {
    _daftar.insert(0, sesi);
    notifyListeners();
  }

  void tandaiSelesai(String id) {
    final index = _daftar.indexWhere((s) => s.id == id);
    if (index != -1) {
      _daftar[index].selesai = true;
      notifyListeners();
    }
  }

  void batalkan(String id) {
    _daftar.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  int jumlahKategori(String kategori) {
    return _daftar.where((s) => s.kategori.toLowerCase() == kategori.toLowerCase()).length;
  }

  int jumlahMode(String mode) {
    return _daftar.where((s) => s.mode.toLowerCase().contains(mode.toLowerCase())).length;
  }
}
