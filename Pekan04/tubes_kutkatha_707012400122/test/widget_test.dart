import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tubes_kutkatha_707012400122/main.dart';
import 'package:tubes_kutkatha_707012400122/model/konsultasi_model.dart';
import 'package:tubes_kutkatha_707012400122/pages/halaman_formulir_konseling.dart';

Widget _aplikasiUji({KonsultasiModel? model}) {
  return ChangeNotifierProvider(
    create: (_) => model ?? KonsultasiModel(),
    child: const AplikasiKutkathaMobile(),
  );
}

void main() {
  test('KonsultasiModel: tambah, tandaiSelesai, dan hitung kategori', () {
    final model = KonsultasiModel();
    final awal = model.totalKonsultasi;

    final sesiBaru = SesiKonsultasi(
      id: 'TEST-KUKAR-01',
      namaPasien: 'Budi Mahasiswa',
      email: 'budi@kutkatha.id',
      namaPsikolog: 'Muhammad Anantha M. R., M.Psi., Psikolog',
      kategori: 'Kecemasan',
      mode: 'Online (Video Call)',
      sesi: 'Sore',
      tanggal: DateTime.now(),
      keluhan: 'Stres menghadapi skripsi dan tugas akhir',
      selesai: false,
    );

    model.tambah(sesiBaru);
    expect(model.totalKonsultasi, awal + 1);
    expect(model.jumlahKategori('Kecemasan'), greaterThanOrEqualTo(1));

    model.tandaiSelesai('TEST-KUKAR-01');
    expect(
      model.daftar.firstWhere((s) => s.id == 'TEST-KUKAR-01').selesai,
      isTrue,
    );
  });

  testWidgets('Navigasi KerangkaNavigasi Kutkatha: Beranda, Profil, Chat, dan Statistik', (tester) async {
    tester.view.physicalSize = const Size(500, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_aplikasiUji());
    await tester.pumpAndSettle();

    // Di Beranda Kutkatha
    expect(find.textContaining('Kutai Kartanegara'), findsWidgets);
    expect(find.text('Daftar Psikolog'), findsOneWidget);
    expect(find.text('Booking Konseling'), findsOneWidget);

    // Buka tab Profil
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    expect(find.text('Muhammad Anantha Mahardika Ridwan'), findsOneWidget);
    expect(find.text('NIM: 707012400122'), findsOneWidget);

    // Buka tab Chat
    await tester.tap(find.text('Chat').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Halo, selamat datang di sesi konseling'), findsOneWidget);

    // Buka tab Statistik
    await tester.tap(find.text('Statistik').last);
    await tester.pumpAndSettle();
    expect(find.text('Tren Kategori Konsultasi Psikologis Kutkatha'), findsOneWidget);
  });

  testWidgets('Validasi Formulir Konseling Kutkatha dan proses simpan', (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final model = KonsultasiModel();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: model,
        child: const MaterialApp(
          home: HalamanFormulirKonseling(
            namaPsikolog: 'Muhammad Anantha M. R., M.Psi., Psikolog',
            spesialisasi: 'Psikolog Klinis Dewasa & Kecemasan',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Cari tombol Daftar Sesi Konsultasi
    final tombolDaftar = find.widgetWithText(ElevatedButton, 'Daftar Sesi Konsultasi');
    expect(tombolDaftar, findsOneWidget);

    // Awalnya tombol dinonaktifkan karena data belum lengkap
    final buttonAwal = tester.widget<ElevatedButton>(tombolDaftar);
    expect(buttonAwal.onPressed, isNull);

    // Isi Nama Pasien
    final fieldNama = find.byType(TextField).at(0);
    await tester.enterText(fieldNama, 'Siti Rahma');

    // Validasi email harus mengandung @
    final fieldEmail = find.byType(TextField).at(1);
    await tester.enterText(fieldEmail, 'siti.kukar.id');
    await tester.pump();
    expect(find.text('Email wajib mengandung karakter @'), findsOneWidget);

    await tester.enterText(fieldEmail, 'siti@kukar.go.id');
    await tester.pump();
    expect(find.text('Email wajib mengandung karakter @'), findsNothing);

    // Isi Keluhan
    final fieldKeluhan = find.byType(TextField).at(2);
    await tester.enterText(fieldKeluhan, 'Sering cemas menjelang ujian komprehensif.');

    // Centang persetujuan syarat
    final checkbox = find.byType(CheckboxListTile);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Sekarang tombol harusnya aktif
    final buttonAktif = tester.widget<ElevatedButton>(tombolDaftar);
    expect(buttonAktif.onPressed, isNotNull);

    // Klik tombol kirim pendaftaran
    await tester.ensureVisible(tombolDaftar);
    await tester.tap(tombolDaftar);
    await tester.pump(); // mulai loading 2 detik

    // Verifikasi indikator loading muncul
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tunggu simulasi asynchronous 2 detik selesai
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verifikasi data berhasil masuk ke model
    expect(model.daftar.any((s) => s.namaPasien == 'Siti Rahma'), isTrue);
  });
}
