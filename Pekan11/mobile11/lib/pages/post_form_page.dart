import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubits/post_cubit.dart';
import '../cubits/post_state.dart';
import '../models/post.dart';
import '../models/upload_file.dart';
import '../utils/helpers.dart';
import '../widgets/app_text_field.dart';
import '../widgets/attachment_tile.dart';
import '../widgets/gradient_button.dart';

// ============================================================
// HALAMAN FORM ARTIKEL
// ============================================================
// Satu halaman untuk dua fungsi:
//   - post == null  -> TAMBAH artikel (POST /api/posts)
//   - post != null  -> UBAH artikel   (PATCH /api/posts/{id})
//
// Artikel boleh membawa 1 file lampiran (gambar, PDF, dokumen, dll).
class PostFormPage extends StatefulWidget {
  final Post? post;

  const PostFormPage({super.key, this.post});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  UploadFile? _newFile; // file baru yang dipilih pengguna
  bool _removeOldFile = false; // true jika lampiran lama ingin dihapus

  bool get isEdit => widget.post != null;

  /// Lampiran lama masih dipakai? (hanya di mode ubah)
  bool get _showOldFile =>
      isEdit && widget.post!.hasFile && !_removeOldFile && _newFile == null;

  @override
  void initState() {
    super.initState();
    // Jika mode ubah, isi form dengan data lama
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _contentController =
        TextEditingController(text: widget.post?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Membuka penjelajah file untuk memilih lampiran
  Future<void> _pickFile() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: allowedFileExtensions,
    );
    if (picked == null) return; // pengguna membatalkan
    final bytes = await picked.readAsBytes();
    if (bytes.length > maxFileSize) {
      showMessage('Ukuran file maksimal 5 MB', isError: true);
      return;
    }
    setState(() {
      _newFile = UploadFile(name: picked.name, bytes: bytes);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final postCubit = context.read<PostCubit>();
    final bool success;
    if (isEdit) {
      success = await postCubit.updatePost(
        widget.post!.id,
        title,
        content,
        file: _newFile,
        removeFile: _removeOldFile && _newFile == null,
      );
    } else {
      success = await postCubit.createPost(title, content, file: _newFile);
    }
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Post' : 'Tulis Post Baru'),
        foregroundColor: Colors.white,
        // AppBar dengan warna gradasi
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kotak tips
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_rounded, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tips: buat judul yang singkat dan menarik ✨',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Kartu form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _titleController,
                      label: 'Judul',
                      icon: Icons.title_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Judul wajib diisi';
                        }
                        if (value.length > 200) {
                          return 'Judul maksimal 200 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _contentController,
                      label: 'Isi artikel',
                      icon: Icons.notes_rounded,
                      maxLines: 10,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Isi artikel wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Kartu lampiran file
              _buildAttachmentCard(),
              const SizedBox(height: 28),
              BlocBuilder<PostCubit, PostState>(
                builder: (context, state) {
                  return GradientButton(
                    text: isEdit ? 'Simpan Perubahan' : 'Terbitkan Post',
                    icon: isEdit ? Icons.save_rounded : Icons.send_rounded,
                    isLoading: state.isSaving,
                    onPressed: _save,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentCard() {
    final hasFile = _newFile != null || _showOldFile;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.attach_file_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Lampiran (opsional)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 1. File baru yang dipilih
          if (_newFile != null) ...[
            // Pratinjau jika file berupa gambar
            if (isImageFile(_newFile!.name))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    _newFile!.bytes,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            AttachmentTile(
              fileName: _newFile!.name,
              subtitle: '${_newFile!.sizeText} • file baru',
              trailing: IconButton(
                tooltip: 'Batal pilih',
                icon: const Icon(Icons.close_rounded, color: AppColors.danger),
                onPressed: () => setState(() => _newFile = null),
              ),
            ),
          ]
          // 2. File lama (mode ubah)
          else if (_showOldFile)
            AttachmentTile(
              fileName: widget.post!.fileName ?? 'Lampiran',
              subtitle: 'Lampiran saat ini',
              trailing: IconButton(
                tooltip: 'Hapus lampiran',
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.danger),
                onPressed: () => setState(() => _removeOldFile = true),
              ),
            ),
          if (hasFile) const SizedBox(height: 12),
          // Tombol pilih / ganti file
          OutlinedButton.icon(
            onPressed: _pickFile,
            icon: Icon(hasFile
                ? Icons.swap_horiz_rounded
                : Icons.cloud_upload_outlined),
            label: Text(hasFile ? 'Ganti File' : 'Pilih File'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gambar, PDF, Word, Excel, PowerPoint, txt, zip • maks. 5 MB',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
