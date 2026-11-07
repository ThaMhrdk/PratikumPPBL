import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/konsultasi_model.dart';

class HalamanDetailKonsultasi extends StatelessWidget {
  final SesiKonsultasi sesi;

  const HalamanDetailKonsultasi({super.key, required this.sesi});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<KonsultasiModel>();
    final item = model.daftar.firstWhere(
      (s) => s.id == sesi.id,
      orElse: () => sesi,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Sesi ${item.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.id,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Chip(
                          label: Text(
                            item.selesai ? 'Konseling Selesai' : 'Sesi Terjadwal',
                            style: TextStyle(
                              color: item.selesai ? Colors.white : Colors.amber.shade900,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: item.selesai ? Colors.teal : Colors.amber.shade100,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _itemDetail('Psikolog', item.namaPsikolog, Icons.psychology),
                    _itemDetail('Kategori', item.kategori, Icons.category_outlined),
                    _itemDetail('Metode Konsultasi', item.mode, Icons.videocam_outlined),
                    _itemDetail('Sesi Waktu', 'Sesi ${item.sesi}', Icons.schedule),
                    _itemDetail('Nama Pasien', item.namaPasien, Icons.person_outline),
                    _itemDetail('Kontak Pasien', item.email, Icons.email_outlined),
                    _itemDetail(
                      'Jadwal Konseling',
                      '${item.tanggal.day}/${item.tanggal.month}/${item.tanggal.year} (WITA)',
                      Icons.calendar_month,
                    ),
                    _itemDetail('Keluhan / Catatan', item.keluhan, Icons.notes),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<KonsultasiModel>().tandaiSelesai(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesi konsultasi berhasil ditandai selesai.'),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Tandai Selesai Konseling'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                context.read<KonsultasiModel>().batalkan(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sesi ${item.id} telah dibatalkan.')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              label: const Text('Batalkan Jadwal', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemDetail(String label, String isi, IconData ikon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 20, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                Text(isi, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
