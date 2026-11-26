import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_theme.dart';

// ============================================================
// FUNGSI BANTUAN
// ============================================================
/// Kunci global agar SnackBar bisa ditampilkan dari mana saja.
/// Dipasang di MaterialApp (lihat main.dart).
final messengerKey = GlobalKey<ScaffoldMessengerState>();

/// Menampilkan pesan di bagian bawah layar.
/// Hijau untuk sukses, merah untuk error.
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

// ------------------------------------------------------------
// FILE LAMPIRAN
// ------------------------------------------------------------
/// Ekstensi file yang boleh diunggah (sama dengan validasi Laravel)
const allowedFileExtensions = [
  'jpg',
  'jpeg',
  'png',
  'gif',
  'webp',
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'txt',
  'zip',
];

/// Batas ukuran file: 5 MB
const maxFileSize = 5 * 1024 * 1024;

/// Mengambil ekstensi file, contoh: "materi.PDF" -> "pdf"
String fileExtension(String fileName) {
  if (!fileName.contains('.')) return '';
  return fileName.split('.').last.toLowerCase();
}

/// Apakah file berupa gambar?
bool isImageFile(String fileName) {
  return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension(fileName));
}

/// Ikon sesuai jenis file
IconData fileIcon(String fileName) {
  switch (fileExtension(fileName)) {
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'webp':
      return Icons.image_rounded;
    case 'pdf':
      return Icons.picture_as_pdf_rounded;
    case 'doc':
    case 'docx':
    case 'txt':
      return Icons.description_rounded;
    case 'xls':
    case 'xlsx':
      return Icons.table_chart_rounded;
    case 'ppt':
    case 'pptx':
      return Icons.slideshow_rounded;
    case 'zip':
      return Icons.folder_zip_rounded;
    default:
      return Icons.insert_drive_file_rounded;
  }
}

/// Warna sesuai jenis file
Color fileColor(String fileName) {
  switch (fileExtension(fileName)) {
    case 'pdf':
      return const Color(0xFFE74C3C); // merah
    case 'doc':
    case 'docx':
    case 'txt':
      return const Color(0xFF0984E3); // biru
    case 'xls':
    case 'xlsx':
      return const Color(0xFF00B894); // hijau
    case 'ppt':
    case 'pptx':
      return const Color(0xFFFDA43C); // oranye
    default:
      return AppColors.primary;
  }
}

/// Membuka URL (file lampiran) di browser / aplikasi lain
Future<void> openUrl(String url) async {
  final success = await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
  if (!success) showMessage('Tidak bisa membuka file', isError: true);
}

// ------------------------------------------------------------
// TANGGAL
// ------------------------------------------------------------
/// Mengubah DateTime menjadi teks, contoh: "14 Nov 2026, 10:00"
String formatTanggal(DateTime? date) {
  if (date == null) return '-';
  const bulan = [
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
  final jam = date.hour.toString().padLeft(2, '0');
  final menit = date.minute.toString().padLeft(2, '0');
  return '${date.day} ${bulan[date.month - 1]} ${date.year}, $jam:$menit';
}
