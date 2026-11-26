import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../cubits/post_cubit.dart';
import '../cubits/post_state.dart';
import '../models/user.dart';
import '../widgets/home_header.dart';
import '../widgets/info_view.dart';
import '../widgets/post_card.dart';
import 'login_page.dart';
import 'post_detail_page.dart';
import 'post_form_page.dart';

// ============================================================
// HALAMAN UTAMA - DAFTAR ARTIKEL
// ============================================================
// Artikel bisa dilihat tanpa login.
// Untuk menulis artikel, pengguna wajib login.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _openAddPost(BuildContext context) {
    final isLoggedIn = context.read<AuthCubit>().state.isLoggedIn;
    if (!isLoggedIn) {
      _openLogin(context); // belum login -> ke halaman login
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostFormPage()),
    );
  }

  /// Menampilkan profil + tombol logout dari bawah layar
  void _showProfile(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis kecil di atas
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: AppColors.mainGradient,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(user.email,
                  style: const TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext); // tutup bottom sheet
                    context.read<AuthCubit>().logout();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddPost(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Tulis Post'),
      ),
      // BlocBuilder: bagian ini otomatis digambar ulang saat state berubah
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return BlocBuilder<PostCubit, PostState>(
            builder: (context, postState) {
              final user = authState.user;
              // Hitung jumlah post milik user yang login
              final myPostCount = postState.posts
                  .where((post) => user != null && post.userId == user.id)
                  .length;
              return Column(
                children: [
                  HomeHeader(
                    user: user,
                    isChecking: authState.isChecking,
                    totalPost: postState.posts.length,
                    myPost: myPostCount,
                    onLoginTap: () => _openLogin(context),
                    onProfileTap: () => _showProfile(context, user!),
                  ),
                  Expanded(child: _buildPostList(context, postState, user)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPostList(BuildContext context, PostState state, User? user) {
    final postCubit = context.read<PostCubit>();
    // 1. Sedang memuat
    if (state.isLoading && state.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    // 2. Gagal memuat
    if (state.errorText != null && state.posts.isEmpty) {
      return InfoView(
        icon: Icons.cloud_off_rounded,
        title: 'Oops, gagal terhubung',
        subtitle: state.errorText!,
        buttonText: 'Coba Lagi',
        onPressed: postCubit.loadPosts,
      );
    }
    // 3. Data kosong
    if (state.posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: postCubit.loadPosts,
        child: ListView(
          children: const [
            SizedBox(height: 40),
            InfoView(
              icon: Icons.article_outlined,
              title: 'Belum ada post',
              subtitle: 'Jadilah yang pertama menulis artikel! ✍️',
            ),
          ],
        ),
      );
    }
    // 4. Tampilkan daftar artikel (tarik ke bawah untuk refresh)
    return RefreshIndicator(
      onRefresh: postCubit.loadPosts,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        itemCount: state.posts.length + 1, // +1 untuk judul "Artikel Terbaru"
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Text(
                'Artikel Terbaru 🔥',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            );
          }
          final post = state.posts[index - 1];
          return PostCard(
            post: post,
            isMine: user != null && post.userId == user.id,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
            ),
          );
        },
      ),
    );
  }
}
