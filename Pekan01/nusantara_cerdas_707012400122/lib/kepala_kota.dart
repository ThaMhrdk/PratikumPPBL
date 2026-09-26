import 'package:flutter/material.dart';

/// Widget tetap (StatelessWidget) untuk menampilkan identitas kota:
/// nama kota, semboyan, dan ikon kota. Bagian ini tidak pernah berubah
/// selama aplikasi berjalan, sehingga cocok sebagai StatelessWidget.
class KepalaKota extends StatelessWidget {
  const KepalaKota({
    super.key,
    required this.namaKota,
    required this.semboyanKota,
    this.ikonKota = Icons.location_city,
  });

  final String namaKota;
  final String semboyanKota;
  final IconData ikonKota;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(ikonKota, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            namaKota,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            semboyanKota,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
