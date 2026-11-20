import 'package:hive/hive.dart';

part 'pembacaan_sensor.g.dart';

@HiveType(typeId: 0)
class PembacaanSensor extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String jenisSensor;

  @HiveField(2)
  late int nilai;

  @HiveField(3)
  late String lokasiPos;

  @HiveField(4)
  late String waktu;

  PembacaanSensor({
    required this.id,
    required this.jenisSensor,
    required this.nilai,
    required this.lokasiPos,
    required this.waktu,
  });
}
