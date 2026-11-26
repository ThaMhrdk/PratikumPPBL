import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sipustaka_mobile_707012400122/config/app_theme.dart';
import 'package:sipustaka_mobile_707012400122/cubits/auth_cubit.dart';
import 'package:sipustaka_mobile_707012400122/cubits/book_cubit.dart';
import 'package:sipustaka_mobile_707012400122/cubits/loan_cubit.dart';
import 'package:sipustaka_mobile_707012400122/main.dart';
import 'package:sipustaka_mobile_707012400122/models/book.dart';
import 'package:sipustaka_mobile_707012400122/models/loan.dart';
import 'package:sipustaka_mobile_707012400122/models/user.dart';
import 'package:sipustaka_mobile_707012400122/pages/book_detail_page.dart';
import 'package:sipustaka_mobile_707012400122/pages/book_form_page.dart';
import 'package:sipustaka_mobile_707012400122/pages/login_page.dart';
import 'package:sipustaka_mobile_707012400122/pages/register_page.dart';
import 'package:sipustaka_mobile_707012400122/services/api_service.dart';
import 'package:sipustaka_mobile_707012400122/widgets/loan_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ApiService buildMockApi({bool withToken = false}) {
    SharedPreferences.setMockInitialValues(
      withToken ? {'sipustaka_token': 'mock_token_123'} : {},
    );
    final client = MockClient((request) async {
      final path = request.url.path;
      if (path.endsWith('/auth/me') && request.method == 'GET') {
        return http.Response(
          jsonEncode({
            'id': 1,
            'name': 'Muhammad Anantha',
            'email': 'anantha@sipustaka.test',
          }),
          200,
        );
      }
      if (path.endsWith('/books') && request.method == 'GET') {
        return http.Response(
          jsonEncode([
            {
              'id': 1,
              'judul': 'Pemrograman Flutter & REST API Laravel Terpadu',
              'penulis': 'Tim Praktikum PPBL',
              'penerbit': 'Telkom University Press',
              'tahun_terbit': 2026,
              'stok': 5,
              'cover_name': null,
              'cover_url': null,
              'created_at': '2026-11-24T10:00:00.000000Z',
              'updated_at': '2026-11-24T10:00:00.000000Z',
            }
          ]),
          200,
        );
      }
      if (path.endsWith('/loans') && request.method == 'GET') {
        return http.Response(
          jsonEncode([
            {
              'id': 10,
              'book_id': 1,
              'user_id': 1,
              'tanggal_pinjam': '2026-11-24',
              'tanggal_kembali': '2026-12-01',
              'status': 'Dipinjam',
              'book': {
                'id': 1,
                'judul': 'Pemrograman Flutter & REST API Laravel Terpadu',
                'penulis': 'Tim Praktikum PPBL',
                'penerbit': 'Telkom University Press',
                'tahun_terbit': 2026,
                'stok': 5,
                'cover_name': null,
                'cover_url': null,
              },
              'user': {
                'id': 1,
                'name': 'Muhammad Anantha',
                'email': 'anantha@sipustaka.test',
              },
            }
          ]),
          200,
        );
      }
      return http.Response(jsonEncode({'message': 'OK'}), 200);
    });
    return ApiService(client: client);
  }

  testWidgets('Guest HomePage and Tab 2 login guard at 360x800', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final api = buildMockApi(withToken: false);
    await tester.pumpWidget(SiPustakaApp(api: api));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Tamu'), findsOneWidget);
    expect(find.text('Tambah Buku'), findsNothing);
    expect(
      find.text('Pemrograman Flutter & REST API Laravel Terpadu'),
      findsOneWidget,
    );

    await tester.tap(find.text('Peminjaman'));
    await tester.pumpAndSettle();
    expect(find.text('Login Sekarang'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Logged-in HomePage + all secondary pages/cards at 360x800', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final api = buildMockApi(withToken: true);
    await tester.pumpWidget(SiPustakaApp(api: api));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Muhammad Anantha'), findsOneWidget);
    expect(find.text('Tambah Buku'), findsOneWidget);

    await tester.tap(find.text('Peminjaman'));
    await tester.pumpAndSettle();
    expect(find.text('Kembalikan'), findsOneWidget);
    expect(tester.takeException(), isNull);

    const sampleBook = Book(
      id: 1,
      judul: 'Pemrograman Flutter Lanjut',
      penulis: 'Tim PPBL',
      penerbit: 'Tel-U Press',
      tahunTerbit: 2026,
      stok: 4,
    );

    Widget wrap(Widget child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(api)),
          BlocProvider(create: (_) => BookCubit(api)),
          BlocProvider(create: (_) => LoanCubit(api)),
        ],
        child: MaterialApp(theme: AppTheme.light, home: child),
      );
    }

    await tester.pumpWidget(wrap(const LoginPage()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(wrap(const RegisterPage()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(wrap(const BookDetailPage(book: sampleBook)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(wrap(const BookFormPage()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    const sampleLoan = Loan(
      id: 2,
      bookId: 1,
      userId: 9,
      tanggalPinjam: '2026-11-24',
      tanggalKembali: '2026-12-01',
      status: 'Dipinjam',
      book: sampleBook,
      user: User(id: 9, name: 'Pengguna Lain', email: 'lain@test.id'),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: LoanCard(
            loan: sampleLoan,
            isMine: false,
            onReturn: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
