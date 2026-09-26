import 'package:flutter/material.dart';

/// Panel laporan warga (StatefulWidget), sebab jumlah laporan dan status
/// pelayanan berubah setiap kali tombol ditekan dan harus tampil ulang
/// lewat setState().
class PanelLaporanWarga extends StatefulWidget {
  const PanelLaporanWarga({super.key});

  @override
  State<PanelLaporanWarga> createState() => _PanelLaporanWargaState();
}

class _PanelLaporanWargaState extends State<PanelLaporanWarga> {
  int _jumlahLaporan = 0;

  void _laporanMasuk() {
    setState(() {
      _jumlahLaporan++;
    });
  }

  void _laporanSelesai() {
    setState(() {
      // Penghitung tidak boleh berkurang di bawah nol.
      if (_jumlahLaporan > 0) {
        _jumlahLaporan--;
      }
    });
  }

  void _resetHarian() {
    setState(() {
      _jumlahLaporan = 0;
    });
  }

  String get _statusPelayanan {
    if (_jumlahLaporan > 10) return 'Perlu Penambahan Petugas';
    if (_jumlahLaporan >= 5) return 'Pelayanan Sibuk';
    return 'Pelayanan Lancar';
  }

  Color get _warnaStatus {
    if (_jumlahLaporan > 10) return Colors.red;
    if (_jumlahLaporan >= 5) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Laporan Warga Hari Ini',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '$_jumlahLaporan',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: _warnaStatus.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _statusPelayanan,
                textAlign: TextAlign.center,
                style: TextStyle(color: _warnaStatus, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _laporanMasuk,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Laporan Masuk'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _laporanSelesai,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Laporan Selesai'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _resetHarian,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Harian'),
            ),
          ],
        ),
      ),
    );
  }
}
