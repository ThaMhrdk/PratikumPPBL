class DataLayanan {
  static const List<Map<String, String>> perizinan = [
    {
      'namaLayanan': 'Izin Usaha Mikro',
      'dinas': 'Dinas Penanaman Modal dan PTSP',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Pengajuan izin usaha untuk pelaku UMKM di Kota Nusantara.',
      'bidang': 'Perizinan',
    },
    {
      'namaLayanan': 'Izin Mendirikan Bangunan',
      'dinas': 'Dinas Pekerjaan Umum dan Tata Ruang',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Perizinan pendirian bangunan baru maupun renovasi.',
      'bidang': 'Perizinan',
    },
    {
      'namaLayanan': 'Izin Keramaian',
      'dinas': 'Satuan Polisi Pamong Praja',
      'jamOperasional': 'Senin - Sabtu, 08.00 - 16.00',
      'keterangan': 'Izin penyelenggaraan kegiatan atau acara warga.',
      'bidang': 'Perizinan',
    },
  ];

  static const List<Map<String, String>> kesehatan = [
    {
      'namaLayanan': 'Pendaftaran Puskesmas Online',
      'dinas': 'Dinas Kesehatan Kota Nusantara',
      'jamOperasional': 'Setiap hari, 07.00 - 20.00',
      'keterangan':
          'Pendaftaran antrean puskesmas terdekat tanpa perlu mengantre di lokasi.',
      'bidang': 'Kesehatan',
    },
    {
      'namaLayanan': 'Jadwal Imunisasi Anak',
      'dinas': 'Dinas Kesehatan Kota Nusantara',
      'jamOperasional': 'Senin - Jumat, 08.00 - 14.00',
      'keterangan': 'Informasi jadwal dan lokasi imunisasi anak di posyandu.',
      'bidang': 'Kesehatan',
    },
    {
      'namaLayanan': 'Layanan Ambulans Darurat',
      'dinas': 'Dinas Kesehatan Kota Nusantara',
      'jamOperasional': '24 jam setiap hari',
      'keterangan': 'Permintaan layanan ambulans untuk kondisi darurat warga.',
      'bidang': 'Kesehatan',
    },
  ];

  static const List<Map<String, String>> transportasi = [
    {
      'namaLayanan': 'Perpanjangan Kartu Bus Kota',
      'dinas': 'Dinas Perhubungan Kota Nusantara',
      'jamOperasional': 'Senin - Jumat, 08.00 - 15.00',
      'keterangan': 'Perpanjangan kartu langganan bus kota Nusantara Cerdas.',
      'bidang': 'Transportasi',
    },
    {
      'namaLayanan': 'Laporan Kerusakan Jalan',
      'dinas': 'Dinas Pekerjaan Umum dan Tata Ruang',
      'jamOperasional': 'Setiap hari, 08.00 - 20.00',
      'keterangan':
          'Pelaporan kondisi jalan rusak agar segera ditindaklanjuti.',
      'bidang': 'Transportasi',
    },
    {
      'namaLayanan': 'Informasi Rute Transportasi Umum',
      'dinas': 'Dinas Perhubungan Kota Nusantara',
      'jamOperasional': 'Setiap hari, 05.00 - 22.00',
      'keterangan': 'Informasi rute dan jadwal transportasi umum kota.',
      'bidang': 'Transportasi',
    },
  ];

  // Gabungan seluruh bidang, dipakai untuk mencari data lengkap sebuah
  // layanan berdasarkan namanya (misalnya pada bagian Layanan Favorit).
  static List<Map<String, String>> get semua => [
        ...perizinan,
        ...kesehatan,
        ...transportasi,
      ];

  static Map<String, String>? cari(String namaLayanan) {
    for (final layanan in semua) {
      if (layanan['namaLayanan'] == namaLayanan) return layanan;
    }
    return null;
  }
}
