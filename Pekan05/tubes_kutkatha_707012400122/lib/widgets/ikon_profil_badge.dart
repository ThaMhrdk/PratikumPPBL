import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

// Ikon tujuan Profil yang dilengkapi badge jumlah booking konsultasi.
// BlocSelector hanya membangun ulang ikon ini ketika totalBooking berubah,
// tanpa membangun ulang NavigationBar maupun NavigationDrawer.
class IkonProfilBadge extends StatelessWidget {
  const IkonProfilBadge({super.key, this.terpilih = false});

  final bool terpilih;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BookingCubit, BookingState, int>(
      selector: (state) => state.totalBooking,
      builder: (context, totalBooking) {
        return Badge(
          isLabelVisible: totalBooking > 0,
          label: Text('$totalBooking'),
          child: Icon(terpilih ? Icons.person : Icons.person_outline),
        );
      },
    );
  }
}
