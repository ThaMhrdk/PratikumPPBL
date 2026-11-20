import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../helpers/hive_helper.dart';
import '../helpers/pengaturan_helper.dart';
import '../models/pembacaan_sensor.dart';

class HalamanRiwayat extends StatefulWidget {
  const HalamanRiwayat({super.key});

  @override
  State<HalamanRiwayat> createState() => _HalamanRiwayatState();
}

class _HalamanRiwayatState extends State<HalamanRiwayat> {
  @override
  void initState() {
    super.initState();
    PengaturanHelper.muatAmbangBatas();
  }

  String _hitungStatusSiaga(
    List<PembacaanSensor> daftar,
    AmbangBatas ambang,
  ) {
    if (daftar.isEmpty) return 'Aman';

    final Map<String, int> terbaruPerJenis = {};
    for (final item in daftar) {
      terbaruPerJenis.putIfAbsent(item.jenisSensor, () => item.nilai);
    }

    final air = terbaruPerJenis['ketinggian_air'] ?? 0;
    final tanah = terbaruPerJenis['pergeseran_tanah'] ?? 0;
    final hujan = terbaruPerJenis['curah_hujan'] ?? 0;

    if (air >= ambang.siagaAir ||
        tanah >= ambang.siagaTanah ||
        hujan >= ambang.siagaHujan) {
      return 'Siaga';
    } else if (air >= ambang.waspadaAir ||
        tanah >= ambang.waspadaTanah ||
        hujan >= ambang.waspadaHujan) {
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

  Future<void> _tampilkanDialogKoreksi(
    BuildContext context,
    PembacaanSensor pembacaan,
  ) async {
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
          decoration: const InputDecoration(
            labelText: 'Nilai pembacaan baru',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (nilaiBaru != null) {
      pembacaan.nilai = nilaiBaru;
      await pembacaan.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AmbangBatas>(
      valueListenable: PengaturanHelper.ambangNotifier,
      builder: (context, ambang, _) {
        return ValueListenableBuilder<Box<PembacaanSensor>>(
          valueListenable: HiveHelper.box.listenable(),
          builder: (context, box, _) {
            final daftar = box.values.toList()
              ..sort((a, b) => b.waktu.compareTo(a.waktu));
            final statusSiaga = _hitungStatusSiaga(daftar, ambang);
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
              body: daftar.isEmpty
                  ? const Center(
                      child: Text('Belum ada riwayat pembacaan sensor.'),
                    )
                  : ListView.builder(
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
                          onDismissed: (_) async {
                            await pembacaan.delete();
                          },
                          child: ListTile(
                            title: Text(
                              '${pembacaan.jenisSensor} • ${pembacaan.lokasiPos}',
                            ),
                            subtitle: Text('Waktu: ${pembacaan.waktu}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Nilai: ${pembacaan.nilai}'),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Koreksi Nilai',
                                  onPressed: () =>
                                      _tampilkanDialogKoreksi(context, pembacaan),
                                ),
                              ],
                            ),
                            onTap: () =>
                                _tampilkanDialogKoreksi(context, pembacaan),
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
