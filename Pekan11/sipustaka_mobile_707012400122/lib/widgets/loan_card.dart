import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/loan.dart';
import '../utils/helpers.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final bool isMine;
  final VoidCallback onReturn;
  final VoidCallback onDelete;

  const LoanCard({
    super.key,
    required this.loan,
    required this.isMine,
    required this.onReturn,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final returned = loan.isReturned;
    final statusColor = returned ? AppColors.success : AppColors.warning;
    final bookTitle = loan.book?.judul ?? 'Buku #${loan.bookId}';
    final borrowerLabel = isMine
        ? 'Milik Saya'
        : 'Peminjam: ${loan.user?.name ?? 'User #${loan.userId}'}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  bookTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  loan.status,
                  style: TextStyle(
                    color: returned ? AppColors.accent : Colors.orange.shade800,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (isMine ? AppColors.primary : Colors.blueGrey)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              borrowerLabel,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isMine ? AppColors.primary : Colors.blueGrey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Pinjam: ${formatTanggalRingkas(loan.tanggalPinjam)}  •  '
            'Kembali: ${formatTanggalRingkas(loan.tanggalKembali)}',
            style: const TextStyle(fontSize: 12.5, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!returned)
                OutlinedButton.icon(
                  onPressed: onReturn,
                  icon: const Icon(Icons.assignment_return_rounded, size: 17),
                  label: const Text('Kembalikan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 17),
                label: const Text('Hapus'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
