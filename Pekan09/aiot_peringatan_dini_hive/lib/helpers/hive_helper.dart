import 'package:hive_flutter/hive_flutter.dart';
import '../models/pembacaan_sensor.dart';

class HiveHelper {
  HiveHelper._();

  static const String namaBoxPembacaan = 'pembacaanSensorBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PembacaanSensorAdapter());
    }
    await Hive.openBox<PembacaanSensor>(namaBoxPembacaan);
  }

  static Box<PembacaanSensor> get box =>
      Hive.box<PembacaanSensor>(namaBoxPembacaan);
}
