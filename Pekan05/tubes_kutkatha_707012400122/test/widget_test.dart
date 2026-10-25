import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_kutkatha_707012400122/cubit/booking_cubit.dart';
import 'package:tubes_kutkatha_707012400122/main.dart';

void main() {
  test('BookingCubit menambah dan membatalkan booking', () {
    final cubit = BookingCubit();
    cubit.tambahBooking(namaPsikolog: 'A', spesialisasi: 'S', jadwal: 'J');
    cubit.tambahBooking(namaPsikolog: 'A', spesialisasi: 'S', jadwal: 'J');
    expect(cubit.state.totalBooking, 1);
    cubit.batalkanBooking('A');
    expect(cubit.state.totalBooking, 0);
    cubit.close();
  });

  testWidgets('Booking tampil di Beranda dan Profil', (tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(BlocProvider(
      create: (context) => BookingCubit(),
      child: const AplikasiKutkatha(),
    ));
    expect(find.text('Belum ada booking'), findsOneWidget);

    await tester.tap(find.text('Cari Psikolog'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Hani Nadia Hendra'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajukan Booking Konsultasi'));
    await tester.pump();
    expect(find.text('Sedang memproses...'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('1 booking aktif'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    // Teks persis (bukan textContaining) agar SnackBar tidak ikut terhitung.
    expect(find.text('Hani Nadia Hendra, M.Psi., Psikolog'), findsOneWidget);
  });
}
