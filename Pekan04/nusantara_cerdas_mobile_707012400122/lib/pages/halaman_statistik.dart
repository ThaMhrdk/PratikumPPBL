import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pengajuan_model.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca model pengajuan secara reaktif melalui context.watch()
    final model = context.watch<PengajuanModel>();

    final perizinan = model.jumlahBidang('Perizinan');
    final kesehatan = model.jumlahBidang('Kesehatan');
    final transportasi = model.jumlahBidang('Transportasi');

    final maxVal = [perizinan, kesehatan, transportasi, 5].reduce((a, b) => a > b ? a : b).toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Ringkasan Total
            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _itemRingkasan('Total Masuk', '${model.totalPengajuan}', Colors.teal.shade900),
                    Container(height: 36, width: 1, color: Colors.teal.shade200),
                    _itemRingkasan('Diproses', '${model.totalDiproses}', Colors.orange.shade800),
                    Container(height: 36, width: 1, color: Colors.teal.shade200),
                    _itemRingkasan('Selesai', '${model.totalSelesai}', Colors.green.shade800),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Judul Grafik
            const Text(
              'Jumlah Pengajuan per Bidang Layanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Data diperbarui secara otomatis ketika ada pengajuan baru dari warga.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            // Diagram Batang (BarChart dari fl_chart)
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxVal + 1,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String bidang;
                        switch (group.x) {
                          case 0:
                            bidang = 'Perizinan';
                            break;
                          case 1:
                            bidang = 'Kesehatan';
                            break;
                          case 2:
                            bidang = 'Transportasi';
                            break;
                          default:
                            bidang = '';
                        }
                        return BarTooltipItem(
                          '$bidang\n${rod.toY.toInt()} berkas',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0) return const SizedBox();
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10, color: Colors.black54),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          String label;
                          switch (value.toInt()) {
                            case 0:
                              label = 'Perizinan';
                              break;
                            case 1:
                              label = 'Kesehatan';
                              break;
                            case 2:
                              label = 'Transportasi';
                              break;
                            default:
                              label = '';
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    checkToShowHorizontalLine: (value) => value % 1 == 0,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: perizinan.toDouble(),
                          color: Colors.blue.shade600,
                          width: 24,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: kesehatan.toDouble(),
                          color: Colors.teal.shade600,
                          width: 24,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: transportasi.toDouble(),
                          color: Colors.orange.shade700,
                          width: 24,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Distribusi Detail Berdasarkan Sesi
            const Text(
              'Distribusi Pengajuan per Sesi Kunjungan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _barisSesi(context, 'Sesi Pagi (08.00 - 11.30)', model.jumlahSesi('Pagi'), Colors.amber.shade700),
            _barisSesi(context, 'Sesi Siang (13.00 - 15.00)', model.jumlahSesi('Siang'), Colors.cyan.shade700),
            _barisSesi(context, 'Sesi Sore (15.30 - 17.00)', model.jumlahSesi('Sore'), Colors.purple.shade700),
          ],
        ),
      );
  }

  Widget _itemRingkasan(String label, String nilai, Color warna) {
    return Column(
      children: [
        Text(
          nilai,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: warna,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _barisSesi(BuildContext context, String namaSesi, int jumlah, Color warna) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(radius: 6, backgroundColor: warna),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  namaSesi,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '$jumlah berkas',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
