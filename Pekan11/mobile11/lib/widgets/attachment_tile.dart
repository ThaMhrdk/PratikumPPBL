import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../utils/helpers.dart';

/// Kotak yang menampilkan satu file lampiran:
/// ikon berwarna + nama file + keterangan + tombol di kanan.
class AttachmentTile extends StatelessWidget {
  final String fileName;
  final String subtitle; // contoh: "1.2 MB" atau "Ketuk untuk membuka"
  final Widget? trailing; // tombol di kanan (hapus / buka)
  final VoidCallback? onTap;

  const AttachmentTile({
    super.key,
    required this.fileName,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = fileColor(fileName);
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(fileIcon(fileName), color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Tanda "?" = tampilkan hanya jika trailing tidak null
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
