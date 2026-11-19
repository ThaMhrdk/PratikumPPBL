import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/pantauan_cubit.dart';
import '../models/sensor.dart';
import '../widgets/sensor_card.dart';
import '../widgets/theme_toggle_button.dart';
import 'halaman_riwayat.dart';

class HalamanSensor extends StatelessWidget {
  const HalamanSensor({super.key});

  static const daftarSensor = [
    Sensor(
      id: 's1',
      nama: 'Sensor Ketinggian Air Hulu',
      jenisSensor: 'ketinggian_air',
      lokasiPos: 'Pos Sungai Cikapundung',
      satuan: 'cm',
      nilaiAwal: 120,
    ),
    Sensor(
      id: 's2',
      nama: 'Sensor Pergeseran Tanah',
      jenisSensor: 'pergeseran_tanah',
      lokasiPos: 'Pos Tebing Dago',
      satuan: 'mm',
      nilaiAwal: 15,
    ),
    Sensor(
      id: 's3',
      nama: 'Sensor Curah Hujan',
      jenisSensor: 'curah_hujan',
      lokasiPos: 'Pos Hulu Cisangkuy',
      satuan: 'mm/jam',
      nilaiAwal: 60,
    ),
    Sensor(
      id: 's4',
      nama: 'Sensor Ketinggian Air Hilir',
      jenisSensor: 'ketinggian_air',
      lokasiPos: 'Pos Bendung Dayeuhkolot',
      satuan: 'cm',
      nilaiAwal: 210,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Sensor AIoT'),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Riwayat Sensor',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HalamanRiwayat()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: daftarSensor.length,
        itemBuilder: (context, index) {
          final sensor = daftarSensor[index];
          return SensorCard(
            sensor: sensor,
            onTambah: () => context.read<PantauanCubit>().tambah(sensor),
            onInputManual: () async {
              final controller = TextEditingController(
                text: sensor.nilaiAwal.toString(),
              );
              final nilaiBaru = await showDialog<int>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Input Manual ${sensor.nama}'),
                  content: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nilai (${sensor.satuan})',
                    ),
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
                      child: const Text('Tambah'),
                    ),
                  ],
                ),
              );
              if (nilaiBaru != null && context.mounted) {
                context.read<PantauanCubit>().tambah(
                  sensor,
                  nilaiManual: nilaiBaru,
                );
              }
            },
          );
        },
      ),
    );
  }
}
