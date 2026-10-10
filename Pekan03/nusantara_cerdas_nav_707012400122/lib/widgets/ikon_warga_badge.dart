// lib/widgets/ikon_warga_badge.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';

/// Ikon tujuan Warga beserta badge jumlah pengajuan.
/// context.select hanya mendengarkan totalPengajuan, dan karena berada di
/// widget tersendiri, hanya badge ini yang dibangun ulang ketika nilainya
/// berubah. NavigationBar dan NavigationRail tidak ikut dibangun ulang.
class IkonWargaBadge extends StatelessWidget {
  const IkonWargaBadge({super.key, required this.terpilih});

  final bool terpilih;

  @override
  Widget build(BuildContext context) {
    final total = context.select<PengajuanModel, int>(
      (model) => model.totalPengajuan,
    );

    return Badge(
      isLabelVisible: total > 0,
      label: Text('$total'),
      child: Icon(terpilih ? Icons.people : Icons.people_outline),
    );
  }
}
