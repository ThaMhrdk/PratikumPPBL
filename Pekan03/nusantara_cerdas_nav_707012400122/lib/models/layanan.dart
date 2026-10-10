// lib/models/layanan.dart
import 'package:flutter/material.dart';

@immutable
class Layanan {
  const Layanan({
    required this.nama,
    required this.bidang,
    required this.deskripsi,
    required this.ikon,
    required this.persyaratan,
    required this.estimasi,
  });

  final String nama;
  final String bidang;
  final String deskripsi;
  final IconData ikon;
  final List<String> persyaratan;
  final String estimasi;
}

const List<String> daftarBidang = ['Perizinan', 'Kesehatan', 'Transportasi'];

const Map<String, IconData> ikonBidang = {
  'Perizinan': Icons.assignment_outlined,
  'Kesehatan': Icons.favorite_border,
  'Transportasi': Icons.directions_bus_outlined,
};

const List<Layanan> daftarLayanan = [
  // ---- Perizinan ----
  Layanan(
    nama: 'Izin Mendirikan Bangunan',
    bidang: 'Perizinan',
    deskripsi: 'Pengajuan izin untuk membangun atau merenovasi bangunan.',
    ikon: Icons.apartment,
    persyaratan: ['KTP pemilik', 'Sertifikat tanah', 'Gambar rencana bangunan'],
    estimasi: '14 hari kerja',
  ),
  Layanan(
    nama: 'Surat Izin Usaha Mikro',
    bidang: 'Perizinan',
    deskripsi: 'Legalitas usaha mikro agar dapat beroperasi secara resmi.',
    ikon: Icons.storefront,
    persyaratan: ['KTP', 'Foto lokasi usaha', 'Surat keterangan RT/RW'],
    estimasi: '3 hari kerja',
  ),
  Layanan(
    nama: 'Izin Keramaian',
    bidang: 'Perizinan',
    deskripsi: 'Izin menyelenggarakan kegiatan yang melibatkan banyak orang.',
    ikon: Icons.celebration,
    persyaratan: [
      'Surat permohonan',
      'Proposal kegiatan',
      'Surat izin lingkungan',
    ],
    estimasi: '5 hari kerja',
  ),
  // ---- Kesehatan ----
  Layanan(
    nama: 'Pendaftaran Puskesmas Online',
    bidang: 'Kesehatan',
    deskripsi: 'Daftar antrean pemeriksaan di puskesmas tanpa datang lebih awal.',
    ikon: Icons.local_hospital,
    persyaratan: ['KTP', 'Kartu BPJS (jika ada)', 'Nomor telepon aktif'],
    estimasi: '1 hari kerja',
  ),
  Layanan(
    nama: 'Imunisasi Anak',
    bidang: 'Kesehatan',
    deskripsi: 'Jadwal dan pendaftaran imunisasi dasar untuk anak.',
    ikon: Icons.vaccines,
    persyaratan: ['Buku KIA', 'Akta kelahiran', 'KTP orang tua'],
    estimasi: '1 hari kerja',
  ),
  Layanan(
    nama: 'Surat Keterangan Sehat',
    bidang: 'Kesehatan',
    deskripsi: 'Surat keterangan sehat untuk keperluan kerja atau pendidikan.',
    ikon: Icons.health_and_safety,
    persyaratan: ['KTP', 'Pas foto 3x4', 'Hasil pemeriksaan dasar'],
    estimasi: '1 hari kerja',
  ),
  // ---- Transportasi ----
  Layanan(
    nama: 'Kartu Angkutan Umum',
    bidang: 'Transportasi',
    deskripsi: 'Kartu langganan untuk bus dan angkutan umum kota.',
    ikon: Icons.directions_bus,
    persyaratan: ['KTP', 'Pas foto 3x4', 'Surat keterangan domisili'],
    estimasi: '2 hari kerja',
  ),
  Layanan(
    nama: 'Izin Trayek Angkutan',
    bidang: 'Transportasi',
    deskripsi: 'Izin operasi angkutan umum pada trayek tertentu.',
    ikon: Icons.alt_route,
    persyaratan: ['KTP pemilik', 'STNK kendaraan', 'Surat permohonan trayek'],
    estimasi: '10 hari kerja',
  ),
  Layanan(
    nama: 'Uji Kelayakan Kendaraan',
    bidang: 'Transportasi',
    deskripsi: 'Pemeriksaan kelayakan kendaraan angkutan umum dan barang.',
    ikon: Icons.car_repair,
    persyaratan: ['STNK', 'KTP pemilik', 'Kendaraan yang akan diuji'],
    estimasi: '1 hari kerja',
  ),
];

Iterable<Layanan> layananBidang(String bidang) {
  return daftarLayanan.where((layanan) => layanan.bidang == bidang);
}
