import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/pantauan_cubit.dart';
import '../helpers/hive_helper.dart';
import '../models/pembacaan_sensor.dart';
import '../models/sensor.dart';
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
                child: daftarItem.isEmpty
                    ? const Center(
                        child: Text('Belum ada pantauan sensor dipilih.'),
                      )
                    : ListView.builder(
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
                  final now = DateTime.now();
                  final waktuSekarang = now.toString();

                  for (int i = 0; i < daftarItem.length; i++) {
                    final item = daftarItem[i];
                    final idUnik = 'ps_${now.microsecondsSinceEpoch}_$i';
                    final pembacaan = PembacaanSensor(
                      id: idUnik,
                      jenisSensor: item.sensor.jenisSensor,
                      nilai: item.nilai,
                      lokasiPos: item.sensor.lokasiPos,
                      waktu: waktuSekarang,
                    );
                    await HiveHelper.box.put(idUnik, pembacaan);
                  }

                  pantauanCubit.kosongkan();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Pembacaan sensor disimpan ke Hive.'),
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
