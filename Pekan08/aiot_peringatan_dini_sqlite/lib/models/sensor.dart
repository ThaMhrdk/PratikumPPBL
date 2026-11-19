class Sensor {
  final String id;
  final String nama;
  final String jenisSensor;
  final String lokasiPos;
  final String satuan;
  final int nilaiAwal;

  const Sensor({
    required this.id,
    required this.nama,
    required this.jenisSensor,
    required this.lokasiPos,
    required this.satuan,
    required this.nilaiAwal,
  });
}

class ItemPantauan {
  final Sensor sensor;
  int nilai;

  ItemPantauan({required this.sensor, required this.nilai});
}
