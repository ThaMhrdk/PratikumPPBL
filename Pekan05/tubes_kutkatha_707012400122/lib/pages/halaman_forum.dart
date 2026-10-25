import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanForum extends StatelessWidget {
  const HalamanForum({super.key});

  static const List<Map<String, String>> _topik = [
    {
      'judul': 'Cara mengatasi rasa cemas berlebihan',
      'penulis': 'Warga Anonim',
      'isi':
          'Belakangan ini saya sering merasa cemas tanpa sebab yang jelas. '
          'Apakah ada warga lain yang punya pengalaman serupa dan tips '
          'untuk menenangkan diri?',
    },
    {
      'judul': 'Berbagi pengalaman konsultasi pertama kali',
      'penulis': 'Warga Anonim',
      'isi':
          'Saya baru pertama kali mencoba layanan konsultasi lewat Kutkatha '
          'dan ingin berbagi pengalaman agar warga lain tidak ragu mencoba.',
    },
    {
      'judul': 'Tips menjaga kesehatan mental saat bekerja',
      'penulis': 'Warga Anonim',
      'isi':
          'Beban kerja yang tinggi kadang membuat kondisi mental terganggu. '
          'Yuk berbagi kebiasaan sehat yang bisa diterapkan sehari-hari.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Tanpa Scaffold, sebab halaman ini tampil di dalam Scaffold
    // milik KerangkaNavigasi.
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _topik.length,
      separatorBuilder: (context, indeks) => const SizedBox(height: 8),
      itemBuilder: (context, indeks) {
        final topik = _topik[indeks];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: Text(topik['judul'] ?? ''),
            subtitle: Text('oleh ${topik['penulis']}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Membuka rincian forum lewat named route, data topik
              // dikirim melalui arguments (bukan nilai tetap).
              Navigator.pushNamed(context, AppRoutes.forumDetail, arguments: topik);
            },
          ),
        );
      },
    );
  }
}
