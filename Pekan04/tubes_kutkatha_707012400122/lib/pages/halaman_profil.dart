import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/konsultasi_model.dart';
import '../navigation/app_routes.dart';

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<KonsultasiModel>();
    final daftar = model.daftar;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.formulirKonseling);
        },
        icon: const Icon(Icons.add),
        label: const Text('Booking Baru'),
        tooltip: 'Jadwalkan konsultasi psikologis baru',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profil Pasien / Warga
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.45),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Muhammad Anantha Mahardika Ridwan',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'NIM: 707012400122',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Warga Kutai Kartanegara • Terverifikasi',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.deepPurple,
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

          // Ringkasan Statistik
          Row(
            children: [
              Expanded(
                child: _kartuRingkas(
                  context,
                  'Total Sesi',
                  '${model.totalKonsultasi}',
                  Icons.event_note,
                  Colors.deepPurple,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _kartuRingkas(
                  context,
                  'Aktif',
                  '${model.totalAktif}',
                  Icons.pending_actions,
                  Colors.amber.shade900,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _kartuRingkas(
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

          // Judul Riwayat Sesi Konsultasi
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Riwayat Jadwal Konsultasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${daftar.length} sesi',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Petunjuk: Ketuk (tap) untuk rincian sesi, tahan lama (long press) untuk menandai sesi selesai.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),

          // Daftar Riwayat dengan GestureDetector
          if (daftar.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    const Text('Belum ada jadwal konsultasi tersimpan.'),
                  ],
                ),
              ),
            )
          else
            ...daftar.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                // GestureDetector untuk sentuhan tunggal dan sentuhan panjang
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailKonsultasi,
                      arguments: item,
                    );
                  },
                  onLongPress: () {
                    context.read<KonsultasiModel>().tandaiSelesai(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.teal.shade800,
                        content: Row(
                          children: [
                            const Icon(Icons.check, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Sesi konsultasi ${item.id} dengan ${item.namaPsikolog} ditandai SELESAI!',
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
                                  color: Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.id,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple.shade800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Kategori: ${item.kategori}',
                                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  item.selesai ? 'Selesai' : 'Aktif',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: item.selesai ? Colors.white : Colors.amber.shade900,
                                  ),
                                ),
                                backgroundColor: item.selesai ? Colors.teal : Colors.amber.shade100,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.namaPsikolog,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Metode: ${item.mode} • Sesi: ${item.sesi}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                          const Divider(height: 16),
                          Row(
                            children: [
                              Icon(Icons.calendar_month, size: 12, color: Colors.grey.shade600),
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
                                    'Rincian / Tahan Selesai',
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
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _kartuRingkas(
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
