import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_cerdas_tema_707012400122/cubit/favorit_cubit.dart';
import 'package:nusantara_cerdas_tema_707012400122/cubit/pengajuan_cubit.dart';
import 'package:nusantara_cerdas_tema_707012400122/cubit/theme_cubit.dart';
import 'package:nusantara_cerdas_tema_707012400122/main.dart';
import 'package:nusantara_cerdas_tema_707012400122/widgets/kartu_layanan.dart';
import 'package:nusantara_cerdas_tema_707012400122/widgets/sakelar_tema.dart';

Widget _aplikasi() => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => FavoritCubit()),
        BlocProvider(create: (context) => PengajuanCubit()),
      ],
      child: const AplikasiNusantaraCerdas(),
    );

void main() {
  test('ThemeCubit beralih antara light dan dark mode', () {
    final cubit = ThemeCubit();
    expect(cubit.state, ThemeMode.light);
    cubit.toggle();
    expect(cubit.state, ThemeMode.dark);
    cubit.toggle();
    expect(cubit.state, ThemeMode.light);
  });

  test('FavoritCubit menandai dan membatalkan tanda', () {
    final cubit = FavoritCubit();
    cubit.tandai('Izin Keramaian');
    expect(cubit.state, {'Izin Keramaian'});
    cubit.batalTandai('Izin Keramaian');
    expect(cubit.state, isEmpty);
  });

  test('PengajuanCubit menghitung totalPengajuan', () {
    final cubit = PengajuanCubit();
    cubit.ajukan('Izin Keramaian');
    cubit.ajukan('Izin Keramaian');
    cubit.ajukan('Jadwal Imunisasi Anak');
    expect(cubit.state.totalPengajuan, 2);
    cubit.kirimSemua();
    expect(cubit.state.totalPengajuan, 0);
  });

  testWidgets('Favorit dan pengajuan pada layar sempit', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_aplikasi());
    await tester.tap(find.text('Layanan').last);
    await tester.pumpAndSettle();

    // Pastikan custom widget KartuLayanan ter-render
    expect(find.byType(KartuLayanan), findsWidgets);

    // Tandai layanan pertama sebagai favorit
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);

    // Buka rincian lalu ajukan permohonan
    await tester.tap(find.text('Izin Usaha Mikro'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajukan Permohonan'));
    await tester.pump();
    expect(find.text('Sedang mengirim...'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Badge jumlah pengajuan muncul pada ikon Warga
    expect(find.text('1'), findsWidgets);

    await tester.tap(find.text('Warga').last);
    await tester.pumpAndSettle();

    // SakelarTema muncul di Halaman Warga
    expect(find.byType(SakelarTema), findsOneWidget);

    // Menguji toggle saklar tema
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Muncul pada bagian Daftar Pengajuan
    expect(find.text('Izin Usaha Mikro'), findsAtLeastNWidgets(1));

    // Gulir ke bawah untuk memastikan bagian Layanan Favorit terlihat
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Layanan Favorit'), findsOneWidget);
  });

  testWidgets('Layar lebar memakai NavigationRail tanpa galat', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_aplikasi());
    expect(find.byType(NavigationRail), findsOneWidget);
    await tester.tap(find.text('Warga').last);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada layanan favorit'), findsOneWidget);
  });
}
