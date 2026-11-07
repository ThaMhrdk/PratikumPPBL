import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/konsultasi_model.dart';

class HalamanStatistikKutkatha extends StatelessWidget {
  const HalamanStatistikKutkatha({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<KonsultasiModel>();

    final kecemasan = model.jumlahKategori('Kecemasan');
    final stres = model.jumlahKategori('Stres Kuliah');
    final keluarga = model.jumlahKategori('Keluarga');
    final remaja = model.jumlahKategori('Remaja');

    final maxVal = [kecemasan, stres, keluarga, remaja, 5].reduce((a, b) => a > b ? a : b).toDouble();

    final onlineCount = model.jumlahMode('Online');
    final tatapMukaCount = model.jumlahMode('Tatap Muka');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Kartu Ringkasan Sesi
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _itemRingkas('Total Jadwal', '${model.totalKonsultasi}', Colors.deepPurple.shade900),
                  Container(height: 36, width: 1, color: Colors.deepPurple.shade200),
                  _itemRingkas('Sesi Aktif', '${model.totalAktif}', Colors.amber.shade900),
                  Container(height: 36, width: 1, color: Colors.deepPurple.shade200),
                  _itemRingkas('Selesai', '${model.totalSelesai}', Colors.teal.shade800),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Judul Grafik
          const Text(
            'Tren Kategori Konsultasi Psikologis Kutkatha',
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Statistik terintegrasi dengan pembaruan dinamis setiap ada pendaftaran konseling baru.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 18),

          // BarChart fl_chart
          SizedBox(
            height: 230,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal + 1,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String label;
                      switch (group.x) {
                        case 0:
                          label = 'Kecemasan';
                          break;
                        case 1:
                          label = 'Stres Kuliah';
                          break;
                        case 2:
                          label = 'Keluarga';
                          break;
                        case 3:
                          label = 'Remaja';
                          break;
                        default:
                          label = '';
                      }
                      return BarTooltipItem(
                        '$label\n${rod.toY.toInt()} sesi',
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
                      reservedSize: 26,
                      interval: 1,
                      getTitlesWidget: (val, _) {
                        if (val % 1 != 0) return const SizedBox();
                        return Text(
                          val.toInt().toString(),
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, _) {
                        String label;
                        switch (val.toInt()) {
                          case 0:
                            label = 'Cemas';
                            break;
                          case 1:
                            label = 'Stres';
                            break;
                          case 2:
                            label = 'Keluarga';
                            break;
                          case 3:
                            label = 'Remaja';
                            break;
                          default:
                            label = '';
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            label,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  checkToShowHorizontalLine: (v) => v % 1 == 0,
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: kecemasan.toDouble(),
                        color: Colors.deepPurple.shade600,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: stres.toDouble(),
                        color: Colors.indigo.shade600,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: keluarga.toDouble(),
                        color: Colors.teal.shade600,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: remaja.toDouble(),
                        color: Colors.pink.shade600,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Metode Konsultasi Terpilih
          const Text(
            'Distribusi Metode Konseling',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _kartuMetode('Online (Video Call / Chat Terenkripsi)', '$onlineCount sesi', Colors.blue, Icons.videocam),
          _kartuMetode('Tatap Muka di Klinik Mitra Tenggarong', '$tatapMukaCount sesi', Colors.deepPurple, Icons.home_work),
        ],
      ),
    );
  }

  Widget _itemRingkas(String label, String nilai, Color warna) {
    return Column(
      children: [
        Text(
          nilai,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: warna,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _kartuMetode(String nama, String jumlah, Color warna, IconData ikon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(ikon, color: warna, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  nama,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                jumlah,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
