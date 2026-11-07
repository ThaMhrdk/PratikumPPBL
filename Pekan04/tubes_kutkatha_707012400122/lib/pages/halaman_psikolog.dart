import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class HalamanPsikolog extends StatelessWidget {
  const HalamanPsikolog({super.key});

  static const List<Map<String, String>> daftarPsikolog = [
    {
      'nama': 'Muhammad Anantha M. R., M.Psi., Psikolog',
      'spesialisasi': 'Psikolog Klinis Dewasa & Kecemasan',
      'jadwal': 'Senin & Rabu, 09.00 - 15.00 WITA',
      'keterangan': 'Menangani kecemasan, serangan panik, depresi ringan, dan manajemen emosi.',
      'rating': '4.9 (128 ulasan)',
    },
    {
      'nama': 'Hani Nadia Hendra, M.Psi., Psikolog',
      'spesialisasi': 'Psikolog Anak & Tumbuh Kembang Remaja',
      'jadwal': 'Selasa & Kamis, 13.00 - 17.00 WITA',
      'keterangan': 'Fokus pada konseling perilaku remaja, minat bakat, dan relasi orang tua.',
      'rating': '4.8 (95 ulasan)',
    },
    {
      'nama': 'Mumpuni Nur Idzati, M.Psi., Psikolog',
      'spesialisasi': 'Konselor Pernikahan & Dinamika Keluarga',
      'jadwal': 'Jumat & Sabtu, 09.00 - 16.00 WITA',
      'keterangan': 'Membantu komunikasi pasangan, mediasi keluarga, dan konseling pranikah.',
      'rating': '4.9 (110 ulasan)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: daftarPsikolog.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = daftarPsikolog[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: const Icon(Icons.psychology, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nama']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['spesialisasi']!,
                            style: TextStyle(fontSize: 12, color: Colors.deepPurple.shade700),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                item['rating']!,
                                style: const TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['keterangan']!,
                  style: const TextStyle(fontSize: 12.5, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['jadwal']!,
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.psikologDetail,
                          arguments: item,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('Rincian'),
                    ),
                    const SizedBox(width: 6),
                    FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.formulirKonseling,
                          arguments: item,
                        );
                      },
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('Booking'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
