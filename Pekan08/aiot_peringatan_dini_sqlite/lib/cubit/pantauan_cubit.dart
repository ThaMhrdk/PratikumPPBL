import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/sensor.dart';

class PantauanCubit extends Cubit<List<ItemPantauan>> {
  PantauanCubit() : super([]);

  void tambah(Sensor sensor, {int? nilaiManual}) {
    final daftar = List<ItemPantauan>.from(state);
    final index = daftar.indexWhere((item) => item.sensor.id == sensor.id);
    if (index >= 0) {
      if (nilaiManual != null) {
        daftar[index].nilai = nilaiManual;
      } else {
        daftar[index].nilai += 20;
      }
    } else {
      daftar.add(
        ItemPantauan(
          sensor: sensor,
          nilai: nilaiManual ?? sensor.nilaiAwal,
        ),
      );
    }
    emit(daftar);
  }

  void kurangi(Sensor sensor) {
    final daftar = List<ItemPantauan>.from(state);
    final index = daftar.indexWhere((item) => item.sensor.id == sensor.id);
    if (index < 0) return;
    if (daftar[index].nilai > 20) {
      daftar[index].nilai -= 20;
    } else {
      daftar.removeAt(index);
    }
    emit(daftar);
  }

  void kosongkan() {
    emit([]);
  }
}
