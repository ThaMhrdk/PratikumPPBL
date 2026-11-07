import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pengajuan_model.dart';

class HalamanRincianPengajuan extends StatelessWidget {
  final Pengajuan pengajuan;

  const HalamanRincianPengajuan({super.key, required this.pengajuan});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    // Cari objek pengajuan terkini dari model
    final item = model.daftar.firstWhere(
      (p) => p.id == pengajuan.id,
      orElse: () => pengajuan,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Rincian ${item.id}'),
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
                            item.selesai ? 'Selesai Ditindaklanjuti' : 'Sedang Diproses',
                            style: TextStyle(
                              color: item.selesai ? Colors.white : Colors.orange.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: item.selesai ? Colors.teal : Colors.orange.shade100,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _barisDetail('Nama Layanan', item.layanan, Icons.business_center_outlined),
                    _barisDetail('Bidang Layanan', item.bidang, Icons.category_outlined),
                    _barisDetail('Nama Pemohon', item.nama, Icons.person_outline),
                    _barisDetail('Email Pemohon', item.email, Icons.email_outlined),
                    _barisDetail('Sesi Kunjungan', 'Sesi ${item.sesi}', Icons.schedule),
                    _barisDetail(
                      'Tanggal Pengajuan',
                      '${item.tanggal.day}/${item.tanggal.month}/${item.tanggal.year} ${item.tanggal.hour}:${item.tanggal.minute.toString().padLeft(2, '0')}',
                      Icons.calendar_month_outlined,
                    ),
                    _barisDetail('Catatan Khusus', item.catatan, Icons.note_alt_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<PengajuanModel>().toggleStatus(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      item.selesai
                          ? 'Status diubah menjadi: Diproses'
                          : 'Status diubah menjadi: Selesai Ditindaklanjuti',
                    ),
                  ),
                );
              },
              icon: Icon(item.selesai ? Icons.undo : Icons.check_circle),
              label: Text(
                item.selesai ? 'Kembalikan ke Status Diproses' : 'Tandai Selesai Ditindaklanjuti',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali ke Halaman Warga'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barisDetail(String label, String nilai, IconData ikon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 20, color: Colors.teal.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                Text(
                  nilai,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
