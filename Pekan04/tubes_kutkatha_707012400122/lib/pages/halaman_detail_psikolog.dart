import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanDetailPsikolog extends StatelessWidget {
  final String nama;
  final String spesialisasi;
  final String jadwal;
  final String keterangan;

  const HalamanDetailPsikolog({
    super.key,
    this.nama = 'Muhammad Anantha M. R., M.Psi., Psikolog',
    this.spesialisasi = 'Psikolog Klinis Dewasa & Kecemasan',
    this.jadwal = 'Senin & Rabu, 09.00 - 15.00 WITA',
    this.keterangan = 'Menangani kecemasan, serangan panik, depresi ringan, dan manajemen emosi.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Psikolog'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.person, size: 52),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nama,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spesialisasi,
                    style: TextStyle(fontSize: 14, color: Colors.deepPurple.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Chip(
                    label: Text(
                      'SIPPK Aktif • Terverifikasi HIMPSI',
                      style: TextStyle(fontSize: 11, color: Colors.teal),
                    ),
                    backgroundColor: Color(0xFFE0F2F1),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            _infoItem('Jadwal Praktik', jadwal, Icons.schedule),
            _infoItem('Layanan & Pendekatan', keterangan, Icons.psychology_outlined),
            _infoItem(
              'Lokasi Konsultasi',
              'Online (Kutkatha Meet) dan Tatap Muka di Klinik Pratama Kutkatha Tenggarong',
              Icons.location_on_outlined,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.formulirKonseling,
                  arguments: {
                    'namaPsikolog': nama,
                    'spesialisasi': spesialisasi,
                  },
                );
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Jadwalkan Konsultasi Sekarang'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String isi, IconData ikon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: Colors.deepPurple, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  isi,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
