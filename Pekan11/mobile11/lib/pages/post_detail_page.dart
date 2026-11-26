import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/post_cubit.dart';
import '../cubits/post_state.dart';
import '../models/post.dart';
import '../utils/helpers.dart';
import '../widgets/attachment_tile.dart';
import 'post_form_page.dart';

// ============================================================
// HALAMAN DETAIL ARTIKEL  (GET /api/posts/{id})
// ============================================================
// Tombol Ubah & Hapus hanya muncul jika artikel milik user yang login.
class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  Future<void> _confirmDelete(BuildContext context, Post post) async {
    // Tampilkan dialog konfirmasi
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.delete_forever_rounded,
            color: AppColors.danger, size: 48),
        title: const Text('Hapus Post?'),
        content: Text(
          '"${post.title}" akan dihapus permanen.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yakin != true || !context.mounted) return;
    final success = await context.read<PostCubit>().deletePost(post.id);
    if (success && context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        // Ambil versi terbaru artikel dari Cubit (misal setelah diubah)
        final current = state.posts.firstWhere(
          (p) => p.id == post.id,
          orElse: () => post,
        );
        // Cek apakah artikel ini milik user yang sedang login
        final user = context.watch<AuthCubit>().state.user;
        final isMine = user != null && current.userId == user.id;
        return Scaffold(
          body: Column(
            children: [
              _buildHeader(context, current, isMine),
              if (state.isSaving) const LinearProgressIndicator(),
              Expanded(child: _buildContent(context, current)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Post post, bool isMine) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12, topPadding + 8, 12, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris tombol: kembali, ubah, hapus
          Row(
            children: [
              _CircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              if (isMine) ...[
                _CircleButton(
                  icon: Icons.edit_rounded,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostFormPage(post: post),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _CircleButton(
                  icon: Icons.delete_rounded,
                  onTap: () => _confirmDelete(context, post),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label kecil
                Wrap(
                  spacing: 8,
                  children: [
                    _Label(text: 'Post #${post.id}'),
                    if (isMine) const _Label(text: '⭐ Milik saya'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      formatTanggal(post.createdAt),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Post post) {
    return RefreshIndicator(
      // Tarik ke bawah untuk mengambil data terbaru dari server
      onRefresh: () => context.read<PostCubit>().loadPostDetail(post.id),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notes_rounded, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Isi Artikel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28),
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 15.5,
                    height: 1.7,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          // Lampiran hanya tampil jika artikel punya file
          if (post.hasFile) ...[
            const SizedBox(height: 16),
            _buildAttachment(post),
          ],
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Terakhir diubah: ${formatTanggal(post.updatedAt)}',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu lampiran: gambar (jika file gambar) + info file + tombol buka
Widget _buildAttachment(Post post) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Icon(Icons.attach_file_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Lampiran',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const Divider(height: 28),
        // Tampilkan gambar langsung dari server
        if (post.hasImage)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => openUrl(post.fileUrl!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  post.imageUrl,
                  height: 220,
                  fit: BoxFit.cover,
                  // Saat gambar masih dimuat
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  // Jika gambar gagal dimuat
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(
                    height: 120,
                    child: Center(
                      child: Icon(Icons.broken_image_rounded,
                          size: 48, color: AppColors.textGrey),
                    ),
                  ),
                ),
              ),
            ),
          ),
        AttachmentTile(
          fileName: post.fileName ?? 'Lampiran',
          subtitle: 'Ketuk untuk membuka / mengunduh',
          onTap: () => openUrl(post.fileUrl!),
          trailing: const Icon(Icons.open_in_new_rounded,
              color: AppColors.primary),
        ),
      ],
    ),
  );
}

/// Tombol bulat transparan di header
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}

/// Label kecil di header
class _Label extends StatelessWidget {
  final String text;

  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
