import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/post.dart';
import '../utils/helpers.dart';

/// Kartu untuk menampilkan satu artikel di halaman utama.
class PostCard extends StatelessWidget {
  final Post post;
  final bool isMine; // true jika artikel milik user yang login
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.isMine,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Pilih warna berdasarkan id agar tiap kartu berbeda warna
    final color = AppColors.cardColors[post.id % AppColors.cardColors.length];
    final initial = post.title.isEmpty ? '?' : post.title[0].toUpperCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kotak huruf pertama judul
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Judul, isi singkat, tanggal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.schedule_rounded,
                                    size: 14, color: AppColors.textGrey),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    formatTanggal(post.createdAt),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                ),
                                // Ikon klip jika ada lampiran
                                if (post.hasFile) ...[
                                  const SizedBox(width: 10),
                                  Icon(
                                    post.hasImage
                                        ? Icons.image_rounded
                                        : Icons.attach_file_rounded,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isMine) ...[
                            const SizedBox(width: 8),
                            const _MineBadge(),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Label kecil "Milik saya"
class _MineBadge extends StatelessWidget {
  const _MineBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Milik saya',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
