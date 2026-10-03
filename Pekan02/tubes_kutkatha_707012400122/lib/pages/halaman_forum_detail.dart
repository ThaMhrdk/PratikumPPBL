import 'package:flutter/material.dart';

class HalamanForumDetail extends StatelessWidget {
  const HalamanForumDetail({
    super.key,
    required this.judul,
    required this.penulis,
    required this.isi,
  });

  final String judul;
  final String penulis;
  final String isi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rincian Forum')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('oleh $penulis', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Text(isi, style: const TextStyle(fontSize: 15, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
