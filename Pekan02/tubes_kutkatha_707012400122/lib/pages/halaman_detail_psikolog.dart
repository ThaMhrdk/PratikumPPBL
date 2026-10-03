import 'package:flutter/material.dart';

class HalamanDetailPsikolog extends StatelessWidget {
  const HalamanDetailPsikolog({
    super.key,
    required this.nama,
    required this.spesialisasi,
    required this.jadwal,
    required this.keterangan,
  });

  final String nama;
  final String spesialisasi;
  final String jadwal;
  final String keterangan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rincian Psikolog')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.person, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              nama,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buatBarisInfo(Icons.psychology_alt_outlined, 'Spesialisasi', spesialisasi),
            const SizedBox(height: 12),
            _buatBarisInfo(Icons.schedule, 'Jadwal Praktik', jadwal),
            const SizedBox(height: 12),
            _buatBarisInfo(Icons.info_outline, 'Keterangan', keterangan),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Menutup halaman sekaligus mengirim nilai balik ke
                  // halaman daftar psikolog, ditampilkan sebagai SnackBar.
                  Navigator.pop(
                    context,
                    'Booking konsultasi dengan $nama berhasil diajukan.',
                  );
                },
                icon: const Icon(Icons.event_available_outlined),
                label: const Text('Ajukan Booking Konsultasi'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buatBarisInfo(IconData ikon, String label, String isi) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ikon, size: 20, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text(isi, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
