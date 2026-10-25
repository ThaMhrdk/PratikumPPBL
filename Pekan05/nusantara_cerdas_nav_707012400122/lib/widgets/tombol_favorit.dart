import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorit_cubit.dart';

class TombolFavorit extends StatelessWidget {
  const TombolFavorit({super.key, required this.namaLayanan});

  final String namaLayanan;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoritCubit, Set<String>, bool>(
      selector: (favorit) => favorit.contains(namaLayanan),
      builder: (context, sudahFavorit) {
        return IconButton(
          tooltip: sudahFavorit ? 'Batalkan favorit' : 'Tandai favorit',
          icon: Icon(
            sudahFavorit ? Icons.star : Icons.star_border,
            color: sudahFavorit ? Colors.amber : null,
          ),
          onPressed: () {
            final cubit = context.read<FavoritCubit>();
            if (sudahFavorit) {
              cubit.batalTandai(namaLayanan);
            } else {
              cubit.tandai(namaLayanan);
            }
          },
        );
      },
    );
  }
}
