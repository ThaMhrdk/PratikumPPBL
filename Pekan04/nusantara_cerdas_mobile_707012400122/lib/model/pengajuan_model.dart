import 'package:flutter/foundation.dart';

class Pengajuan {
  final String id;
  final String nama;
  final String email;
  final String layanan;
  final String bidang;
  final String sesi;
  final DateTime tanggal;
  bool selesai;
  final String catatan;

  Pengajuan({
    required this.id,
    required this.nama,
    required this.email,
    required this.layanan,
    required this.bidang,
    required this.sesi,
    required this.tanggal,
    this.selesai = false,
    this.catatan = '',
  });
}

class PengajuanModel extends ChangeNotifier {
  // Data riwayat pengajuan awal agar tampilan tidak kosong saat pertama dibuka
  final List<Pengajuan> _daftar = [
    Pengajuan(
      id: 'PGJ-001',
      nama: 'Muhammad Anantha Mahardika Ridwan',
      email: 'anantha@smartcity.nusantara.go.id',
      layanan: 'Izin Usaha Mikro (IUMK)',
      bidang: 'Perizinan',
      sesi: 'Pagi',
      tanggal: DateTime.now().subtract(const Duration(days: 2)),
      selesai: true,
      catatan: 'Dokumen verifikasi usaha UMKM telah lengkap.',
    ),
    Pengajuan(
      id: 'PGJ-002',
      nama: 'Muhammad Anantha Mahardika Ridwan',
      email: 'anantha@smartcity.nusantara.go.id',
      layanan: 'Pendaftaran Puskesmas Online',
      bidang: 'Kesehatan',
      sesi: 'Siang',
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
      selesai: false,
      catatan: 'Menunggu konfirmasi antrean poli umum.',
    ),
    Pengajuan(
      id: 'PGJ-003',
      nama: 'Muhammad Anantha Mahardika Ridwan',
      email: 'anantha@smartcity.nusantara.go.id',
      layanan: 'Perpanjangan Kartu Bus Kota',
      bidang: 'Transportasi',
      sesi: 'Sore',
      tanggal: DateTime.now(),
      selesai: false,
      catatan: 'Proses pencetakan kartu fisik di loket balai kota.',
    ),
  ];

  List<Pengajuan> get daftar => List.unmodifiable(_daftar);

  int get totalPengajuan => _daftar.length;
  int get totalSelesai => _daftar.where((p) => p.selesai).length;
  int get totalDiproses => _daftar.where((p) => !p.selesai).length;

  void tambah(Pengajuan pengajuan) {
    _daftar.insert(0, pengajuan);
    notifyListeners();
  }

  void tandaiSelesai(String id) {
    final index = _daftar.indexWhere((p) => p.id == id);
    if (index != -1) {
      _daftar[index].selesai = true;
      notifyListeners();
    }
  }

  void toggleStatus(String id) {
    final index = _daftar.indexWhere((p) => p.id == id);
    if (index != -1) {
      _daftar[index].selesai = !_daftar[index].selesai;
      notifyListeners();
    }
  }

  int jumlahBidang(String bidang) {
    return _daftar.where((p) => p.bidang.toLowerCase() == bidang.toLowerCase()).length;
  }

  int jumlahSesi(String sesi) {
    return _daftar.where((p) => p.sesi.toLowerCase() == sesi.toLowerCase()).length;
  }
}
