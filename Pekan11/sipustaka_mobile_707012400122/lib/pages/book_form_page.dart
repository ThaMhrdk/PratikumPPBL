import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubits/book_cubit.dart';
import '../cubits/book_state.dart';
import '../models/book.dart';
import '../models/upload_file.dart';
import '../utils/helpers.dart';
import '../widgets/app_text_field.dart';
import '../widgets/attachment_tile.dart';
import '../widgets/gradient_button.dart';

// ============================================================
// HALAMAN FORM BUKU (TAMBAH POST /books & UBAH PATCH /books/{id})
// ============================================================
class BookFormPage extends StatefulWidget {
  final Book? book;

  const BookFormPage({super.key, this.book});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _penulisCtrl;
  late final TextEditingController _penerbitCtrl;
  late final TextEditingController _tahunCtrl;
  late final TextEditingController _stokCtrl;

  UploadFile? _newCover;
  bool _removeOldCover = false;

  bool get isEdit => widget.book != null;
  bool get _showOldCover =>
      isEdit && widget.book!.hasCover && !_removeOldCover && _newCover == null;

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.book?.judul ?? '');
    _penulisCtrl = TextEditingController(text: widget.book?.penulis ?? '');
    _penerbitCtrl = TextEditingController(text: widget.book?.penerbit ?? '');
    _tahunCtrl = TextEditingController(
      text: widget.book != null ? '${widget.book!.tahunTerbit}' : '',
    );
    _stokCtrl = TextEditingController(
      text: widget.book != null ? '${widget.book!.stok}' : '',
    );
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _penulisCtrl.dispose();
    _penerbitCtrl.dispose();
    _tahunCtrl.dispose();
    _stokCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCover() async {
    final picked = await FilePicker.pickFile(type: FileType.any);
    if (picked == null) return;
    if (!isAllowedCover(picked.name)) {
      showMessage('Format sampul harus jpg, jpeg, atau png', isError: true);
      return;
    }
    final bytes = await picked.readAsBytes();
    if (bytes.length > maxCoverSize) {
      showMessage('Ukuran sampul maksimal 2 MB', isError: true);
      return;
    }
    setState(() {
      _newCover = UploadFile(name: picked.name, bytes: bytes);
      _removeOldCover = false;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final judul = _judulCtrl.text.trim();
    final penulis = _penulisCtrl.text.trim();
    final penerbit = _penerbitCtrl.text.trim();
    final tahunTerbit = int.parse(_tahunCtrl.text.trim());
    final stok = int.parse(_stokCtrl.text.trim());

    final cubit = context.read<BookCubit>();
    final bool ok;
    if (isEdit) {
      ok = await cubit.updateBook(
        id: widget.book!.id,
        judul: judul,
        penulis: penulis,
        penerbit: penerbit,
        tahunTerbit: tahunTerbit,
        stok: stok,
        cover: _newCover,
        removeCover: _removeOldCover && _newCover == null,
      );
    } else {
      ok = await cubit.createBook(
        judul: judul,
        penulis: penulis,
        penerbit: penerbit,
        tahunTerbit: tahunTerbit,
        stok: stok,
        cover: _newCover,
      );
    }
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Data Buku' : 'Tambah Buku Baru'),
        foregroundColor: Colors.white,
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _judulCtrl,
                      label: 'Judul Buku',
                      icon: Icons.book_outlined,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Judul wajib diisi';
                        }
                        if (v.length > 200) return 'Judul maksimal 200 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _penulisCtrl,
                      label: 'Penulis',
                      icon: Icons.person_outline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Penulis wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _penerbitCtrl,
                      label: 'Penerbit',
                      icon: Icons.business_outlined,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Penerbit wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _tahunCtrl,
                      label: 'Tahun Terbit (1900-2100)',
                      icon: Icons.calendar_today_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Tahun terbit wajib diisi';
                        }
                        if (int.tryParse(v.trim()) == null) {
                          return 'Tahun harus berupa angka';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _stokCtrl,
                      label: 'Stok Eksemplar',
                      icon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Stok wajib diisi';
                        }
                        if (int.tryParse(v.trim()) == null) {
                          return 'Stok harus berupa angka';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCoverCard(),
              const SizedBox(height: 24),
              BlocBuilder<BookCubit, BookState>(
                builder: (context, state) {
                  return GradientButton(
                    text: isEdit ? 'Simpan Perubahan' : 'Simpan Buku',
                    icon: isEdit ? Icons.save_rounded : Icons.add_circle_outline,
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

  Widget _buildCoverCard() {
    final hasCover = _newCover != null || _showOldCover;
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
              Icon(Icons.image_outlined, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sampul Buku (opsional)',
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
          if (_newCover != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  _newCover!.bytes,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AttachmentTile(
              fileName: _newCover!.name,
              subtitle: '${_newCover!.sizeText} • sampul baru',
              trailing: IconButton(
                tooltip: 'Batal pilih',
                icon: const Icon(Icons.close_rounded, color: AppColors.danger),
                onPressed: () => setState(() => _newCover = null),
              ),
            ),
          ] else if (_showOldCover) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.book!.coverImageUrl,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
            AttachmentTile(
              fileName: widget.book!.coverName ?? 'Sampul saat ini',
              subtitle: 'Sampul tersimpan di server',
              trailing: IconButton(
                tooltip: 'Hapus sampul',
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.danger,
                ),
                onPressed: () => setState(() => _removeOldCover = true),
              ),
            ),
          ],
          if (hasCover) const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickCover,
            icon: Icon(
              hasCover
                  ? Icons.swap_horiz_rounded
                  : Icons.cloud_upload_outlined,
            ),
            label: Text(hasCover ? 'Ganti Sampul' : 'Pilih Sampul'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 15),
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
            'Format: jpg, jpeg, png • maks. 2 MB',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
