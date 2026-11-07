import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/pengajuan_cubit.dart';
import '../cubit/pengajuan_state.dart';

class IkonWargaBadge extends StatelessWidget {
  const IkonWargaBadge({super.key, this.terpilih = false});

  final bool terpilih;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PengajuanCubit, PengajuanState, int>(
      selector: (state) => state.totalPengajuan,
      builder: (context, totalPengajuan) {
        return Badge(
          isLabelVisible: totalPengajuan > 0,
          label: Text('$totalPengajuan'),
          child: Icon(terpilih ? Icons.person : Icons.person_outline),
        );
      },
    );
  }
}
