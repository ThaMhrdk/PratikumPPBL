import 'package:flutter/material.dart';

class HalamanRincianLayanan extends StatelessWidget {
  const HalamanRincianLayanan({
    super.key,
    required this.namaLayanan,
    required this.dinas,
    required this.jamOperasional,
    required this.keterangan,
  });

  final String namaLayanan;
  final String dinas;
  final String jamOperasional;
  final String keterangan;

  @override
  Widget build(BuildContext context) {
    // Scaffold sendiri, sebab halaman ini dibuka sebagai halaman penuh
    // melalui named route dan memerlukan AppBar beserta tombol kembali.
    return Scaffold(
      appBar: AppBar(title: Text(namaLayanan)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              namaLayanan,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buatBarisInfo(Icons.apartment, 'Dinas Penanggung Jawab', dinas),
            const SizedBox(height: 12),
            _buatBarisInfo(Icons.schedule, 'Jam Operasional', jamOperasional),
            const SizedBox(height: 12),
            _buatBarisInfo(Icons.info_outline, 'Keterangan', keterangan),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Menutup halaman sekaligus mengirim nilai balik ke
                  // halaman daftar layanan, ditampilkan sebagai SnackBar.
                  Navigator.pop(
                    context,
                    'Permohonan $namaLayanan telah diajukan.',
                  );
                },
                icon: const Icon(Icons.send_outlined),
                label: const Text('Ajukan Permohonan'),
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
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(isi, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
