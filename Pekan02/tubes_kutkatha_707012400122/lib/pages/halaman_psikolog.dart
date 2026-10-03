import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanPsikolog extends StatefulWidget {
  const HalamanPsikolog({super.key});

  @override
  State<HalamanPsikolog> createState() => _HalamanPsikologState();
}

class _HalamanPsikologState extends State<HalamanPsikolog> {
  static const List<Map<String, String>> _daftarPsikolog = [
    {
      'nama': 'Muhammad Anantha Mahardika Ridwan, M.Psi., Psikolog',
      'spesialisasi': 'Psikolog Klinis Dewasa',
      'jadwal': 'Senin & Rabu, 09.00 - 12.00',
      'keterangan': 'Menangani kecemasan, stres, dan masalah emosi dewasa.',
    },
    {
      'nama': 'Hani Nadia Hendra, M.Psi., Psikolog',
      'spesialisasi': 'Psikolog Anak & Remaja',
      'jadwal': 'Selasa & Kamis, 13.00 - 16.00',
      'keterangan': 'Fokus pada tumbuh kembang dan masalah perilaku anak.',
    },
    {
      'nama': 'Mumpuni Nur Idzati, M.Psi., Psikolog',
      'spesialisasi': 'Konseling Pernikahan & Keluarga',
      'jadwal': 'Jumat, 09.00 - 15.00',
      'keterangan': 'Membantu komunikasi dan relasi dalam keluarga.',
    },
  ];

  // Membuka rincian psikolog lewat named route, lalu menunggu (await)
  // nilai balik dari tombol Ajukan Booking untuk ditampilkan sebagai SnackBar.
  Future<void> _bukaRincian(Map<String, String> psikolog) async {
    final hasil = await Navigator.pushNamed(
      context,
      AppRoutes.psikologDetail,
      arguments: psikolog,
    );
    if (!mounted) return;
    if (hasil is String) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(hasil)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Psikolog')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _daftarPsikolog.length,
        separatorBuilder: (context, indeks) => const SizedBox(height: 8),
        itemBuilder: (context, indeks) {
          final psikolog = _daftarPsikolog[indeks];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(psikolog['nama'] ?? ''),
              subtitle: Text(psikolog['spesialisasi'] ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _bukaRincian(psikolog),
            ),
          );
        },
      ),
    );
  }
}
