import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/pantauan_cubit.dart';
import '../models/sensor.dart';
import '../models/pembacaan_sensor.dart';
import '../db/database_helper.dart';
import '../widgets/pantauan_summary_bar.dart';
import '../widgets/theme_toggle_button.dart';
import 'halaman_riwayat.dart';

class HalamanPantauan extends StatelessWidget {
  const HalamanPantauan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantauan Sensor Aktif'),
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
      body: BlocBuilder<PantauanCubit, List<ItemPantauan>>(
        builder: (context, daftarItem) {
          final totalSensor = daftarItem.length;
          final totalNilai = daftarItem.fold(0, (a, b) => a + b.nilai);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: daftarItem.length,
                  itemBuilder: (context, index) {
                    final item = daftarItem[index];
                    return ListTile(
                      title: Text(item.sensor.nama),
                      subtitle: Text(
                        '${item.sensor.lokasiPos} • ${item.sensor.jenisSensor}',
                      ),
                      trailing: Text('${item.nilai} ${item.sensor.satuan}'),
                    );
                  },
                ),
              ),
              PantauanSummaryBar(
                totalSensor: totalSensor,
                totalNilai: totalNilai,
                onKosongkan: () => context.read<PantauanCubit>().kosongkan(),
                onSimpan: () async {
                  if (daftarItem.isEmpty) return;
                  final pantauanCubit = context.read<PantauanCubit>();
                  final messenger = ScaffoldMessenger.of(context);
                  final waktuSekarang = DateTime.now().toString();

                  for (final item in daftarItem) {
                    await DatabaseHelper.instance.tambahPembacaan(
                      PembacaanSensor(
                        jenisSensor: item.sensor.jenisSensor,
                        nilai: item.nilai,
                        lokasiPos: item.sensor.lokasiPos,
                        waktu: waktuSekarang,
                      ),
                    );
                  }

                  pantauanCubit.kosongkan();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Pembacaan sensor berhasil disimpan.'),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
