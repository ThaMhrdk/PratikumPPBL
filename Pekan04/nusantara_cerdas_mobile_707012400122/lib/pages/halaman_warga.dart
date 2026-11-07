import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pengajuan_model.dart';
import '../navigation/app_routes.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    final daftar = model.daftar;

    return Scaffold(
      // FloatingActionButton untuk langsung membuka formulir pengajuan baru menggunakan named route
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.formulirPengajuan);
        },
        icon: const Icon(Icons.add),
        label: const Text('Pengajuan Baru'),
        tooltip: 'Buka formulir pengajuan baru',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Kartu Identitas Profil Warga
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Muhammad Anantha Mahardika Ridwan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'NIM: 707012400122',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Warga Digital Kota Nusantara • Terverifikasi',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.teal.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Ringkasan Statistik Singkat Warga
          Row(
            children: [
              Expanded(
                child: _buatKartuRingkasan(
                  context,
                  'Total Pengajuan',
                  '${model.totalPengajuan}',
                  Icons.assignment_outlined,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buatKartuRingkasan(
                  context,
                  'Diproses',
                  '${model.totalDiproses}',
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buatKartuRingkasan(
                  context,
                  'Selesai',
                  '${model.totalSelesai}',
                  Icons.check_circle_outline,
                  Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Judul Riwayat Pengajuan
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Riwayat Pengajuan Permohonan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${daftar.length} berkas',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Petunjuk: Ketuk (tap) kartu untuk rincian, tahan lama (long press) untuk menandai selesai.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),

          // Daftar Kartu Riwayat dengan GestureDetector
          if (daftar.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    const Text('Belum ada riwayat permohonan.'),
                  ],
                ),
              ),
            )
          else
            ...daftar.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                // GestureDetector membungkus setiap kartu riwayat pengajuan
                child: GestureDetector(
                  onTap: () {
                    // Sentuhan tunggal: membuka rincian pengajuan melalui named route
                    Navigator.pushNamed(
                      context,
                      AppRoutes.rincianPengajuan,
                      arguments: item,
                    );
                  },
                  onLongPress: () {
                    // Sentuhan panjang: menandai pengajuan selesai ditindaklanjuti
                    context.read<PengajuanModel>().tandaiSelesai(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.teal.shade700,
                        content: Row(
                          children: [
                            const Icon(Icons.check, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Pengajuan ${item.layanan} (${item.id}) ditandai SELESAI ditindaklanjuti!',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: item.selesai ? Colors.teal.shade300 : Colors.grey.shade300,
                        width: item.selesai ? 1.5 : 0.8,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.id,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Bidang ${item.bidang}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  item.selesai ? 'Selesai' : 'Diproses',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: item.selesai ? Colors.white : Colors.orange.shade900,
                                  ),
                                ),
                                backgroundColor: item.selesai ? Colors.teal : Colors.orange.shade100,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.layanan,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pemohon: ${item.nama} • Sesi: ${item.sesi}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                          const Divider(height: 16),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${item.tanggal.day}/${item.tanggal.month}/${item.tanggal.year}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.touch_app,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Detail / Tahan Selesai',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 70), // Spasi agar tidak tertutup FAB
        ],
      ),
    );
  }

  Widget _buatKartuRingkasan(
    BuildContext context,
    String judul,
    String nilai,
    IconData ikon,
    Color warna,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(ikon, color: warna, size: 24),
            const SizedBox(height: 4),
            Text(
              nilai,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: warna,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              judul,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
