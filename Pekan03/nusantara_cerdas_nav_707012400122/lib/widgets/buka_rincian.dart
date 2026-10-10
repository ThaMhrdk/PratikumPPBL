// lib/widgets/buka_rincian.dart
import 'package:flutter/material.dart';

import '../models/layanan.dart';

/// Membuka halaman rincian lewat named route '/rincian', lalu menampilkan
/// nilai balik dari Navigator.pop(context, nilai) sebagai SnackBar.
Future<void> bukaRincianLayanan(BuildContext context, Layanan layanan) async {
  // Ambil messenger sebelum await agar context tidak dipakai setelah jeda async.
  final messenger = ScaffoldMessenger.of(context);

  final hasil = await Navigator.pushNamed<String>(
    context,
    '/rincian',
    arguments: layanan,
  );

  if (hasil != null) {
    messenger.showSnackBar(SnackBar(content: Text(hasil)));
  }
}
