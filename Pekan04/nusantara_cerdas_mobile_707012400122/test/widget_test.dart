import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_cerdas_mobile_707012400122/main.dart';
import 'package:nusantara_cerdas_mobile_707012400122/model/pengajuan_model.dart';
import 'package:nusantara_cerdas_mobile_707012400122/pages/halaman_rincian_layanan.dart';
import 'package:provider/provider.dart';

Widget _aplikasiUji({PengajuanModel? model}) {
  return ChangeNotifierProvider(
    create: (_) => model ?? PengajuanModel(),
    child: const AplikasiNusantaraCerdasMobile(),
  );
}

void main() {
  test('PengajuanModel menambah dan menandai selesai pengajuan', () {
    final model = PengajuanModel();
    final awal = model.totalPengajuan;

    final pBaru = Pengajuan(
      id: 'TEST-001',
      nama: 'Budi Test',
      email: 'budi@test.com',
      layanan: 'Izin Usaha Mikro (IUMK)',
      bidang: 'Perizinan',
      sesi: 'Pagi',
      tanggal: DateTime.now(),
    );

    model.tambah(pBaru);
    expect(model.totalPengajuan, awal + 1);
    expect(model.jumlahBidang('Perizinan'), greaterThanOrEqualTo(1));

    model.tandaiSelesai('TEST-001');
    expect(model.daftar.firstWhere((p) => p.id == 'TEST-001').selesai, isTrue);
  });

  testWidgets('Navigasi berpindah antar tab Layanan, Warga, Chat, dan Statistik', (tester) async {
    tester.view.physicalSize = const Size(500, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_aplikasiUji());
    await tester.pumpAndSettle();

    // Berada di tab Layanan
    expect(find.text('Perizinan'), findsOneWidget);
    expect(find.text('Kesehatan'), findsOneWidget);

    // Pindah ke tab Warga
    await tester.tap(find.text('Warga').last);
    await tester.pumpAndSettle();

    expect(find.text('Muhammad Anantha Mahardika Ridwan'), findsOneWidget);
    expect(find.text('NIM: 707012400122'), findsOneWidget);
    expect(find.text('Pengajuan Baru'), findsOneWidget);

    // Scroll dan uji GestureDetector longPress pada riwayat pengajuan pertama
    final itemPertama = find.text('Izin Usaha Mikro (IUMK)').last;
    await tester.ensureVisible(itemPertama);
    await tester.pumpAndSettle();

    await tester.longPress(itemPertama);
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    // Pindah ke tab Chat
    await tester.tap(find.text('Chat').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Selamat datang di Layanan Tanya Petugas'), findsOneWidget);

    // Pindah ke tab Statistik
    await tester.tap(find.text('Statistik').last);
    await tester.pumpAndSettle();
    expect(find.text('Jumlah Pengajuan per Bidang Layanan'), findsOneWidget);
  });

  testWidgets('Validasi formulir pengajuan layanan dan proses kirim', (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final model = PengajuanModel();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: model,
        child: const MaterialApp(
          home: HalamanRincianLayanan(
            namaLayanan: 'Izin Usaha Mikro (IUMK)',
            bidang: 'Perizinan',
            dinas: 'Dinas Penanaman Modal',
            keterangan: 'Izin usaha UMKM.',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tombol kirim awalnya nonaktif (disabled)
    final tombolKirim = find.widgetWithText(ElevatedButton, 'Kirim Pengajuan Permohonan');
    expect(tester.widget<ElevatedButton>(tombolKirim).onPressed, isNull);

    // Isi nama pemohon
    await tester.enterText(find.byType(TextField).at(0), 'Anantha Mahardika');
    await tester.pump();
    expect(tester.widget<ElevatedButton>(tombolKirim).onPressed, isNull);

    // Isi email tidak valid (tanpa @)
    await tester.enterText(find.byType(TextField).at(1), 'anantha.email');
    await tester.pump();
    expect(find.text('Email wajib mengandung karakter @'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(tombolKirim).onPressed, isNull);

    // Perbaiki email valid
    await tester.enterText(find.byType(TextField).at(1), 'anantha@telkomuniversity.ac.id');
    await tester.pump();
    expect(find.text('Email wajib mengandung karakter @'), findsNothing);

    // Pilih sesi radio button
    final sesiPagi = find.textContaining('Sesi Pagi');
    await tester.ensureVisible(sesiPagi);
    await tester.tap(sesiPagi);
    await tester.pump();

    // Centang checkbox persetujuan
    final checkbox = find.byType(CheckboxListTile);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pump();

    // Sekarang tombol aktif!
    await tester.ensureVisible(tombolKirim);
    await tester.pumpAndSettle();
    expect(tester.widget<ElevatedButton>(tombolKirim).onPressed, isNotNull);

    // Tekan tombol kirim
    await tester.tap(tombolKirim);
    await tester.pump();

    // Menampilkan status loading
    expect(find.text('Sedang Memproses Pengajuan...'), findsOneWidget);

    // Tunggu simulasi delay 2 detik
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Data baru berhasil ditambahkan ke model
    expect(model.daftar.any((p) => p.nama == 'Anantha Mahardika'), isTrue);
  });
}
