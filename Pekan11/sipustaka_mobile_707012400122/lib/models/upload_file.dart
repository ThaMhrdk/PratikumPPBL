import 'dart:typed_data';

// ============================================================
// MODEL SAMPUL BUKU YANG AKAN DIUNGGAH
// ============================================================
class UploadFile {
  final String name;
  final Uint8List bytes;

  const UploadFile({required this.name, required this.bytes});

  String get sizeText {
    final kb = bytes.length / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }
}
