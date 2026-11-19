import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/pembacaan_sensor.dart';

class HalamanRiwayat extends StatefulWidget {
  const HalamanRiwayat({super.key});

  @override
  State<HalamanRiwayat> createState() => _HalamanRiwayatState();
}

class _HalamanRiwayatState extends State<HalamanRiwayat> {
  late Future<List<PembacaanSensor>> _daftarPembacaan;

  @override
  void initState() {
    super.initState();
    _muatUlangData();
  }

  void _muatUlangData() {
    setState(() {
      _daftarPembacaan = DatabaseHelper.instance.ambilSemuaPembacaan();
    });
  }

  String _hitungStatusSiaga(List<PembacaanSensor> daftar) {
    if (daftar.isEmpty) return 'Aman';

    // Mengambil nilai pembacaan terbaru per jenis_sensor dari SQLite
    // (daftar sudah terurut berdasarkan id DESC)
    final Map<String, int> terbaruPerJenis = {};
    for (final item in daftar) {
      terbaruPerJenis.putIfAbsent(item.jenisSensor, () => item.nilai);
    }

    final air = terbaruPerJenis['ketinggian_air'] ?? 0;
    final tanah = terbaruPerJenis['pergeseran_tanah'] ?? 0;
    final hujan = terbaruPerJenis['curah_hujan'] ?? 0;

    if (air >= 200 || tanah >= 30 || hujan >= 100) {
      return 'Siaga';
    } else if (air >= 100 || tanah >= 15 || hujan >= 50) {
      return 'Waspada';
    }
    return 'Aman';
  }

  Color _warnaStatus(String status) {
    switch (status) {
      case 'Siaga':
        return Colors.red;
      case 'Waspada':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PembacaanSensor>>(
      future: _daftarPembacaan,
      builder: (context, snapshot) {
        final daftar = snapshot.data ?? [];
        final statusSiaga = _hitungStatusSiaga(daftar);
        final warnaStatus = _warnaStatus(statusSiaga);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Riwayat Sensor'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Chip(
                  backgroundColor: warnaStatus,
                  label: Text(
                    'Status: $statusSiaga',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (daftar.isEmpty) {
                return const Center(
                  child: Text('Belum ada riwayat pembacaan sensor.'),
                );
              }
              return ListView.builder(
                itemCount: daftar.length,
                itemBuilder: (context, index) {
                  final pembacaan = daftar[index];
                  return Dismissible(
                    key: ValueKey(pembacaan.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      await DatabaseHelper.instance.hapusPembacaan(
                        pembacaan.id!,
                      );
                      _muatUlangData();
                    },
                    child: ListTile(
                      title: Text(
                        '${pembacaan.jenisSensor} • ${pembacaan.lokasiPos}',
                      ),
                      subtitle: Text('Waktu: ${pembacaan.waktu}'),
                      trailing: Text('Nilai: ${pembacaan.nilai}'),
                      onTap: () async {
                        final controller = TextEditingController(
                          text: pembacaan.nilai.toString(),
                        );
                        final nilaiBaru = await showDialog<int>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Koreksi Nilai Sensor'),
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(
                                  context,
                                  int.tryParse(controller.text),
                                ),
                                child: const Text('Simpan'),
                              ),
                            ],
                          ),
                        );
                        if (nilaiBaru != null) {
                          await DatabaseHelper.instance.ubahPembacaan(
                            PembacaanSensor(
                              id: pembacaan.id,
                              jenisSensor: pembacaan.jenisSensor,
                              nilai: nilaiBaru,
                              lokasiPos: pembacaan.lokasiPos,
                              waktu: pembacaan.waktu,
                            ),
                          );
                          _muatUlangData();
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
