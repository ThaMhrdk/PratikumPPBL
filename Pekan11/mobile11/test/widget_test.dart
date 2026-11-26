import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile11/config/app_theme.dart';
import 'package:mobile11/cubits/auth_cubit.dart';
import 'package:mobile11/cubits/post_cubit.dart';
import 'package:mobile11/main.dart';
import 'package:mobile11/models/post.dart';
import 'package:mobile11/pages/login_page.dart';
import 'package:mobile11/pages/post_detail_page.dart';
import 'package:mobile11/pages/post_form_page.dart';
import 'package:mobile11/pages/register_page.dart';
import 'package:mobile11/services/api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ApiService buildMockApi() {
    SharedPreferences.setMockInitialValues({});
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/posts') && request.method == 'GET') {
        return http.Response(
          jsonEncode([
            {
              'id': 1,
              'user_id': 1,
              'title': 'Artikel Panjang Tentang Pemprograman Bergerak Lanjut',
              'content': 'Ini adalah konten artikel pengujian untuk layar 360px.',
              'file_name': 'panduan_modul_11_flutter.pdf',
              'file_url': 'http://192.168.0.111:8000/api/posts/1/file',
              'created_at': '2026-11-24T10:00:00.000000Z',
              'updated_at': '2026-11-24T10:00:00.000000Z',
            }
          ]),
          200,
        );
      }
      return http.Response(jsonEncode({'message': 'OK'}), 200);
    });
    return ApiService(client: client);
  }

  testWidgets('HomePage renders cleanly at narrow 360x800 viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final api = buildMockApi();
    await tester.pumpWidget(MyApp(api: api));
    await tester.pumpAndSettle();

    expect(find.textContaining('Halo, Tamu'), findsOneWidget);
    expect(find.text('Artikel Panjang Tentang Pemprograman Bergerak Lanjut'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Login, Register, PostDetail, PostForm render cleanly at 360x800', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final api = buildMockApi();
    final samplePost = Post(
      id: 1,
      userId: 1,
      title: 'Contoh Judul Artikel',
      content: 'Konten artikel pengujian antarmuka responsif.',
      fileName: 'lampiran.pdf',
      fileUrl: 'http://192.168.0.111:8000/api/posts/1/file',
      createdAt: DateTime(2026, 11, 24, 10, 0),
      updatedAt: DateTime(2026, 11, 24, 10, 0),
    );

    Widget wrapWithProviders(Widget child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(api)),
          BlocProvider(create: (_) => PostCubit(api)),
        ],
        child: MaterialApp(theme: AppTheme.light, home: child),
      );
    }

    await tester.pumpWidget(wrapWithProviders(const LoginPage()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(wrapWithProviders(const RegisterPage()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(wrapWithProviders(PostDetailPage(post: samplePost)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(wrapWithProviders(const PostFormPage()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
