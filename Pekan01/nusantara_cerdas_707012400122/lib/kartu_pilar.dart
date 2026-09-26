import 'package:flutter/material.dart';

/// Kartu ringkasan satu pilar smart city (StatelessWidget), sebab isinya
/// tetap selama aplikasi berjalan: nama pilar, ikon, dan deskripsi singkat.
class KartuPilar extends StatelessWidget {
  const KartuPilar({
    super.key,
    required this.namaPilar,
    required this.ikon,
    required this.deskripsi,
  });

  final String namaPilar;
  final IconData ikon;
  final String deskripsi;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ikon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(
              namaPilar,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              deskripsi,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
