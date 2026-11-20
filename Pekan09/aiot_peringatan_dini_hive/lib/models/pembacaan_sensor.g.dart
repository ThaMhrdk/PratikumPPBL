// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pembacaan_sensor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PembacaanSensorAdapter extends TypeAdapter<PembacaanSensor> {
  @override
  final int typeId = 0;

  @override
  PembacaanSensor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PembacaanSensor(
      id: fields[0] as String,
      jenisSensor: fields[1] as String,
      nilai: fields[2] as int,
      lokasiPos: fields[3] as String,
      waktu: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PembacaanSensor obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jenisSensor)
      ..writeByte(2)
      ..write(obj.nilai)
      ..writeByte(3)
      ..write(obj.lokasiPos)
      ..writeByte(4)
      ..write(obj.waktu);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PembacaanSensorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
