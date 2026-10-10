// lib/models/pengajuan_model.dart
import 'package:flutter/foundation.dart';

import 'layanan.dart';

class PengajuanModel extends ChangeNotifier {
  final List<Layanan> _daftar = [];

  List<Layanan> get daftar => List.unmodifiable(_daftar);

  int get totalPengajuan => _daftar.length;

  bool sudahDiajukan(String namaLayanan) {
    return _daftar.any((layanan) => layanan.nama == namaLayanan);
  }

  /// Mengembalikan true jika layanan berhasil ditambahkan,
  /// false jika layanan tersebut sudah ada di daftar pengajuan.
  bool tambah(Layanan layanan) {
    if (sudahDiajukan(layanan.nama)) return false;
    _daftar.add(layanan);
    notifyListeners();
    return true;
  }

  void hapus(String namaLayanan) {
    final jumlahAwal = _daftar.length;
    _daftar.removeWhere((layanan) => layanan.nama == namaLayanan);
    if (_daftar.length != jumlahAwal) {
      notifyListeners();
    }
  }

  void kosongkan() {
    if (_daftar.isEmpty) return;
    _daftar.clear();
    notifyListeners();
  }
}
