import 'package:flutter/material.dart';

class HalamanDetail extends StatelessWidget {
  const HalamanDetail({
    super.key,
    required this.judul,
    required this.keterangan,
  });
  final String judul;
  final String keterangan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(keterangan, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(context, 'Data dari halaman detail'),
                    child: const Text('Kembali dengan Nilai'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
