import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_cerdas_tema_707012400122/cubit/favorit_cubit.dart';
import 'package:nusantara_cerdas_tema_707012400122/cubit/pengajuan_cubit.dart';
import 'package:nusantara_cerdas_tema_707012400122/cubit/theme_cubit.dart';
import 'package:nusantara_cerdas_tema_707012400122/main.dart';

void main() {
  testWidgets('Capture Screenshots Fast', (tester) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    final outDir = Directory(
        r'C:\Users\THA\.gemini\antigravity\brain\0da3968b-d6ba-41cf-8d65-43c0d94645a6\scratch\screenshots');
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }

    final themeCubit = ThemeCubit();
    final favoritCubit = FavoritCubit();
    final pengajuanCubit = PengajuanCubit();

    // Data simulasi warga
    favoritCubit.tandai('Izin Usaha Mikro');
    favoritCubit.tandai('Pendaftaran Puskesmas Online');
    pengajuanCubit.ajukan('Izin Usaha Mikro');

    final app = MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: favoritCubit),
        BlocProvider.value(value: pengajuanCubit),
      ],
      child: const RepaintBoundary(
        child: AplikasiNusantaraCerdas(),
      ),
    );

    Future<void> capture(String name) async {
      await tester.pump(const Duration(milliseconds: 200));
      final boundary =
          tester.renderObject(find.byType(RepaintBoundary).first)
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      File('${outDir.path}/$name.png').writeAsBytesSync(pngBytes);
      print('Saved: $name.png');
    }

    await tester.pumpWidget(app);
    await tester.pump(const Duration(milliseconds: 200));

    // 1. Beranda Light Mode
    await capture('beranda_light');

    // 2. Layanan Light Mode
    await tester.tap(find.text('Layanan').last);
    await tester.pump(const Duration(milliseconds: 200));
    await capture('layanan_light');

    // 3. Warga Light Mode
    await tester.tap(find.text('Warga').last);
    await tester.pump(const Duration(milliseconds: 200));
    await capture('warga_light');

    // 4. Toggle Mode Gelap via Switch
    await tester.tap(find.byType(Switch));
    await tester.pump(const Duration(milliseconds: 300));
    await capture('warga_dark');

    // 5. Layanan Dark Mode
    await tester.tap(find.text('Layanan').last);
    await tester.pump(const Duration(milliseconds: 200));
    await capture('layanan_dark');

    // 6. Beranda Dark Mode
    await tester.tap(find.text('Beranda').last);
    await tester.pump(const Duration(milliseconds: 200));
    await capture('beranda_dark');
  });
}
