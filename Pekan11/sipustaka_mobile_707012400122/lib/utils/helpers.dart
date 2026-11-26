import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_theme.dart';

// ============================================================
// FUNGSI BANTUAN SIPUSTAKA
// ============================================================
final messengerKey = GlobalKey<ScaffoldMessengerState>();

/// Menampilkan SnackBar hijau (sukses) atau merah (error).
void showMessage(String text, {bool isError = false}) {
  messengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.danger : AppColors.success,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
}

// Validasi sampul sesuai StoreBookRequest / UpdateBookRequest Laravel:
// ['nullable', 'file', 'max:2048', 'mimes:jpg,jpeg,png']
const allowedCoverExtensions = ['jpg', 'jpeg', 'png'];
const maxCoverSize = 2 * 1024 * 1024; // 2 MB

String fileExtension(String fileName) {
  if (!fileName.contains('.')) return '';
  return fileName.split('.').last.toLowerCase();
}

bool isAllowedCover(String fileName) {
  return allowedCoverExtensions.contains(fileExtension(fileName));
}

Future<void> openUrl(String url) async {
  final success = await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
  if (!success) showMessage('Tidak bisa membuka URL sampul', isError: true);
}

const _bulanShort = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

String formatTanggal(DateTime? date) {
  if (date == null) return '-';
  final jam = date.hour.toString().padLeft(2, '0');
  final menit = date.minute.toString().padLeft(2, '0');
  return '${date.day} ${_bulanShort[date.month - 1]} ${date.year}, $jam:$menit';
}

String formatIsoDate(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}

String formatTanggalRingkas(String? rawDate) {
  if (rawDate == null || rawDate.trim().isEmpty) return '-';
  final parsed = DateTime.tryParse(rawDate);
  if (parsed == null) return rawDate;
  return '${parsed.day} ${_bulanShort[parsed.month - 1]} ${parsed.year}';
}
