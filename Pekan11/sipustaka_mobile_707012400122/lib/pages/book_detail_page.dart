import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/book_cubit.dart';
import '../cubits/book_state.dart';
import '../cubits/loan_cubit.dart';
import '../cubits/loan_state.dart';
import '../models/book.dart';
import '../utils/helpers.dart';
import '../widgets/attachment_tile.dart';
import '../widgets/gradient_button.dart';
import 'book_form_page.dart';

// ============================================================
// HALAMAN DETAIL BUKU (GET /api/books/{id})
// ============================================================
class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  Future<void> _confirmDelete(BuildContext context, Book current) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(
          Icons.delete_forever_rounded,
          color: AppColors.danger,
          size: 48,
        ),
        title: const Text('Hapus Buku?'),
        content: Text(
          '"${current.judul}" akan dihapus permanen.',
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
    final ok = await context.read<BookCubit>().deleteBook(current.id);
    if (ok && context.mounted) Navigator.pop(context);
  }

  Future<void> _showBorrowSheet(BuildContext context, Book current) async {
    DateTime tglPinjam = DateTime.now();
    DateTime? tglKembali = DateTime.now().add(const Duration(days: 7));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Pinjam Buku',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    current.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 18),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.date_range_rounded,
                      color: AppColors.primary,
                    ),
                    title: const Text('Tanggal Pinjam'),
                    subtitle: Text(formatTanggalRingkas(formatIsoDate(tglPinjam))),
                    trailing: TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: tglPinjam,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setSheetState(() => tglPinjam = picked);
                        }
                      },
                      child: const Text('Ubah'),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.event_available_rounded,
                      color: AppColors.primary,
                    ),
                    title: const Text('Rencana Tanggal Kembali'),
                    subtitle: Text(
                      tglKembali == null
                          ? 'Opsional (tidak diisi)'
                          : formatTanggalRingkas(formatIsoDate(tglKembali!)),
                    ),
                    trailing: TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: tglKembali ?? tglPinjam,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setSheetState(() => tglKembali = picked);
                        }
                      },
                      child: const Text('Ubah'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  BlocBuilder<LoanCubit, LoanState>(
                    builder: (_, loanState) {
                      return GradientButton(
                        text: 'Ajukan Peminjaman',
                        icon: Icons.check_rounded,
                        isLoading: loanState.isSaving,
                        onPressed: () async {
                          final ok = await context.read<LoanCubit>().createLoan(
                                bookId: current.id,
                                tanggalPinjam: formatIsoDate(tglPinjam),
                                tanggalKembali: tglKembali == null
                                    ? null
                                    : formatIsoDate(tglKembali!),
                              );
                          if (ok && sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthCubit>().state.isLoggedIn;
    return BlocBuilder<BookCubit, BookState>(
      builder: (context, state) {
        final current = state.books.firstWhere(
          (b) => b.id == book.id,
          orElse: () => book,
        );
        return Scaffold(
          body: Column(
            children: [
              _buildHeader(context, current, isLoggedIn),
              if (state.isSaving) const LinearProgressIndicator(),
              Expanded(child: _buildBody(context, current, isLoggedIn)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Book current, bool isLoggedIn) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12, topPadding + 8, 12, 24),
      decoration: const BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              if (isLoggedIn) ...[
                _CircleButton(
                  icon: Icons.edit_rounded,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookFormPage(book: current),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _CircleButton(
                  icon: Icons.delete_rounded,
                  onTap: () => _confirmDelete(context, current),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _HeaderBadge(text: 'Buku #${current.id}'),
                    _HeaderBadge(text: 'Stok: ${current.stok}'),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  current.judul,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  current.penulis,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, Book current, bool isLoggedIn) {
    return RefreshIndicator(
      onRefresh: () => context.read<BookCubit>().loadBookDetail(current.id),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (current.hasCover) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () => openUrl(current.coverUrl!),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        current.coverImageUrl,
                        height: 230,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            height: 230,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (_, _, _) => const SizedBox(
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              size: 48,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AttachmentTile(
                    fileName: current.coverName ?? 'Sampul Buku',
                    subtitle: 'Ketuk untuk membuka via GET /books/${current.id}/cover',
                    onTap: () => openUrl(current.coverUrl!),
                    trailing: const Icon(
                      Icons.open_in_new_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Buku',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const Divider(height: 24),
                _InfoRow(label: 'Judul', value: current.judul),
                _InfoRow(label: 'Penulis', value: current.penulis),
                _InfoRow(label: 'Penerbit', value: current.penerbit),
                _InfoRow(label: 'Tahun Terbit', value: '${current.tahunTerbit}'),
                _InfoRow(label: 'Stok Tersedia', value: '${current.stok} eksemplar'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (isLoggedIn)
            GradientButton(
              text: 'Pinjam Buku Ini',
              icon: Icons.library_add_check_rounded,
              onPressed: () => _showBorrowSheet(context, current),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Login terlebih dahulu untuk meminjam atau mengubah data buku.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13.5),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class _HeaderBadge extends StatelessWidget {
  final String text;

  const _HeaderBadge({required this.text});

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
