import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pengajuan_model.dart';

class HalamanRincianLayanan extends StatefulWidget {
  final String namaLayanan;
  final String bidang;
  final String dinas;
  final String keterangan;

  const HalamanRincianLayanan({
    super.key,
    this.namaLayanan = 'Izin Usaha Mikro (IUMK)',
    this.bidang = 'Perizinan',
    this.dinas = 'Dinas Penanaman Modal dan PTSP',
    this.keterangan = 'Layanan permohonan penerbitan surat izin usaha terpadu warga Kota Nusantara.',
  });

  @override
  State<HalamanRincianLayanan> createState() => _HalamanRincianLayananState();
}

class _HalamanRincianLayananState extends State<HalamanRincianLayanan> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _catatanController = TextEditingController();

  bool _setujuSyarat = false;
  String? _sesiTerpilih;
  bool _sedangMengirim = false;

  bool get _formLengkap {
    final namaOk = _namaController.text.trim().isNotEmpty;
    final email = _emailController.text.trim();
    final emailOk = email.isNotEmpty && email.contains('@');
    return namaOk && emailOk && _setujuSyarat && _sesiTerpilih != null;
  }

  @override
  void initState() {
    super.initState();
    _namaController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _bersihkanFormulir() {
    setState(() {
      _namaController.clear();
      _emailController.clear();
      _catatanController.clear();
      _setujuSyarat = false;
      _sesiTerpilih = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulir pengajuan telah dibersihkan.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _kirimPengajuan() async {
    if (!_formLengkap || _sedangMengirim) return;

    setState(() => _sedangMengirim = true);

    // Simulasi pengiriman data ke server dinas terkait selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final idAcak = 'PGJ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final pengajuanBaru = Pengajuan(
      id: idAcak,
      nama: _namaController.text.trim(),
      email: _emailController.text.trim(),
      layanan: widget.namaLayanan,
      bidang: widget.bidang,
      sesi: _sesiTerpilih!,
      tanggal: DateTime.now(),
      selesai: false,
      catatan: _catatanController.text.trim().isEmpty
          ? 'Pengajuan baru dari aplikasi mobile.'
          : _catatanController.text.trim(),
    );

    // Simpan ke PengajuanModel (Provider)
    context.read<PengajuanModel>().tambah(pengajuanBaru);

    setState(() => _sedangMengirim = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal.shade800,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Permohonan ${widget.namaLayanan} ($idAcak) berhasil dikirim!',
              ),
            ),
          ],
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final email = _emailController.text.trim();
    final emailError = email.isNotEmpty && !email.contains('@')
        ? 'Email wajib mengandung karakter @'
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pengajuan'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bersihkanFormulir,
        tooltip: 'Bersihkan formulir',
        child: const Icon(Icons.refresh),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Informasi Layanan dengan GestureDetector (onTap dan onLongPress)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(widget.namaLayanan),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bidang: ${widget.bidang}'),
                        const SizedBox(height: 4),
                        Text('Instansi: ${widget.dinas}'),
                        const SizedBox(height: 8),
                        Text(widget.keterangan),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Layanan: ${widget.namaLayanan} | Instansi: ${widget.dinas}',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.namaLayanan,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Bidang ${widget.bidang} • ${widget.dinas}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ketuk kartu untuk detail, tahan untuk info singkat',
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.touch_app, size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // TextField Nama Lengkap
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap Pemohon *',
                hintText: 'Masukkan nama sesuai KTP',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // TextField Email dengan validasi karakter '@'
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Aktif *',
                hintText: 'contoh: nama@domain.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
                errorText: emailError,
                helperText: 'Wajib menyertakan tanda @',
              ),
            ),
            const SizedBox(height: 12),

            // TextField Catatan Tambahan (opsional)
            TextField(
              controller: _catatanController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Catatan / Deskripsi Kebutuhan (Opsional)',
                hintText: 'Tuliskan informasi pendukung jika ada',
                prefixIcon: Icon(Icons.note_alt_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // RadioButton Pilihan Sesi Kunjungan
            Text(
              'Pilih Sesi Kunjungan Balai Kota *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Sesi Pagi (08.00 - 11.30 WITA)'),
                    subtitle: const Text('Prioritas loket administrasi awal'),
                    value: 'Pagi',
                    groupValue: _sesiTerpilih,
                    onChanged: (val) => setState(() => _sesiTerpilih = val),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Sesi Siang (13.00 - 15.00 WITA)'),
                    subtitle: const Text('Verifikasi berkas dan konsultasi'),
                    value: 'Siang',
                    groupValue: _sesiTerpilih,
                    onChanged: (val) => setState(() => _sesiTerpilih = val),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Sesi Sore (15.30 - 17.00 WITA)'),
                    subtitle: const Text('Pengambilan dokumen & layanan mandiri'),
                    value: 'Sore',
                    groupValue: _sesiTerpilih,
                    onChanged: (val) => setState(() => _sesiTerpilih = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Checkbox Persetujuan Data Pribadi
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _setujuSyarat,
              title: const Text(
                'Saya menyetujui pemrosesan data pribadi untuk permohonan layanan publik ini *',
                style: TextStyle(fontSize: 13),
              ),
              subtitle: const Text(
                'Sesuai ketentuan UU Perlindungan Data Pribadi Kota Nusantara.',
                style: TextStyle(fontSize: 11),
              ),
              onChanged: (val) => setState(() => _setujuSyarat = val ?? false),
            ),
            const SizedBox(height: 16),

            // ElevatedButton Kirim Pengajuan dengan Status Sedang Mengirim
            ElevatedButton.icon(
              onPressed: (_formLengkap && !_sedangMengirim) ? _kirimPengajuan : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: _sedangMengirim
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(
                _sedangMengirim
                    ? 'Sedang Memproses Pengajuan...'
                    : 'Kirim Pengajuan Permohonan',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
