// lib/pages/halaman_rincian_layanan.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/layanan.dart';
import '../models/pengajuan_model.dart';
import '../widgets/tombol_favorit.dart';

class HalamanRincianLayanan extends StatefulWidget {
  const HalamanRincianLayanan({super.key, required this.layanan});

  final Layanan layanan;

  @override
  State<HalamanRincianLayanan> createState() => _HalamanRincianLayananState();
}

class _HalamanRincianLayananState extends State<HalamanRincianLayanan> {
  // State lokal: hanya penting bagi halaman ini, maka cukup setState().
  bool _sedangMengirim = false;

  Future<void> _ajukanPermohonan() async {
    final pengajuan = context.read<PengajuanModel>();
    final navigator = Navigator.of(context);
    final layanan = widget.layanan;

    setState(() {
      _sedangMengirim = true;
    });

    // Simulasi proses pengiriman ke dinas terkait.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final berhasil = pengajuan.tambah(layanan);

    setState(() {
      _sedangMengirim = false;
    });

    // Nilai balik dibaca oleh halaman pemanggil (ditampilkan sebagai SnackBar).
    navigator.pop(
      berhasil
          ? 'Permohonan "${layanan.nama}" berhasil diajukan'
          : '"${layanan.nama}" sudah ada di daftar pengajuan',
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final layanan = widget.layanan;

    // select: widget ini hanya perlu tahu apakah layanan ini sudah diajukan.
    final sudahDiajukan = context.select<PengajuanModel, bool>(
      (model) => model.sudahDiajukan(layanan.nama),
    );
    final bisaDitekan = !_sedangMengirim && !sudahDiajukan;

    return PopScope(
      canPop: !_sedangMengirim,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rincian Layanan'),
          actions: [TombolFavorit(namaLayanan: layanan.nama)],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 28, child: Icon(layanan.ikon, size: 28)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(layanan.nama, style: tema.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Chip(label: Text(layanan.bidang)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(layanan.deskripsi),
                const SizedBox(height: 24),
                Text('Persyaratan', style: tema.textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final syarat in layanan.persyaratan)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(syarat),
                  ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.schedule),
                  title: const Text('Estimasi penyelesaian'),
                  subtitle: Text(layanan.estimasi),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: bisaDitekan ? _ajukanPermohonan : null,
              icon: _sedangMengirim
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(sudahDiajukan ? Icons.check : Icons.send),
              label: Text(
                _sedangMengirim
                    ? 'Mengirim...'
                    : sudahDiajukan
                        ? 'Sudah Dalam Pengajuan'
                        : 'Ajukan Permohonan',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
