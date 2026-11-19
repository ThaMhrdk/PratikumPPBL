import 'package:flutter/material.dart';
import '../models/sensor.dart';

class SensorCard extends StatelessWidget {
  final Sensor sensor;
  final VoidCallback onTambah;
  final VoidCallback? onInputManual;

  const SensorCard({
    super.key,
    required this.sensor,
    required this.onTambah,
    this.onInputManual,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        onTap: onInputManual,
        title: Text(
          sensor.nama,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          '${sensor.lokasiPos} (${sensor.jenisSensor})\nNilai simulasi: ${sensor.nilaiAwal} ${sensor.satuan}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
          tooltip: 'Catat pembacaan sensor',
          onPressed: onTambah,
        ),
      ),
    );
  }
}
