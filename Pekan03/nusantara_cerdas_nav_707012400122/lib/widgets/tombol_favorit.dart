// lib/widgets/tombol_favorit.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorit_model.dart';

/// Ikon bintang untuk menandai layanan favorit.
/// - watch  : warna ikon mengikuti status favorit (perlu dibangun ulang).
/// - read   : di dalam onPressed hanya memanggil operasi, tanpa mendengarkan.
class TombolFavorit extends StatelessWidget {
  const TombolFavorit({super.key, required this.namaLayanan});

  final String namaLayanan;

  @override
  Widget build(BuildContext context) {
    final aktif = context.watch<FavoritModel>().apakahFavorit(namaLayanan);

    return IconButton(
      tooltip: aktif ? 'Batalkan favorit' : 'Tandai favorit',
      onPressed: () {
        final favorit = context.read<FavoritModel>();
        if (favorit.apakahFavorit(namaLayanan)) {
          favorit.batalTandai(namaLayanan);
        } else {
          favorit.tandai(namaLayanan);
        }
      },
      icon: Icon(
        aktif ? Icons.star : Icons.star_border,
        color: aktif ? Colors.amber.shade700 : null,
      ),
    );
  }
}
