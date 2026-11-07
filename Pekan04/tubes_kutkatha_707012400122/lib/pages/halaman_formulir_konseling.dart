import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/konsultasi_model.dart';

class HalamanFormulirKonseling extends StatefulWidget {
  final String namaPsikolog;
  final String spesialisasi;

  const HalamanFormulirKonseling({
    super.key,
    this.namaPsikolog = 'Muhammad Anantha M. R., M.Psi., Psikolog',
    this.spesialisasi = 'Psikolog Klinis Dewasa & Kecemasan',
  });

  @override
  State<HalamanFormulirKonseling> createState() => _HalamanFormulirKonselingState();
}

class _HalamanFormulirKonselingState extends State<HalamanFormulirKonseling> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _keluhanController = TextEditingController();

  String _kategoriTerpilih = 'Kecemasan';
  String? _modeTerpilih = 'Online (Video Call)';
  String? _sesiTerpilih = 'Pagi';
  bool _setujuSyarat = false;
  bool _sedangMengirim = false;

  bool get _formLengkap {
    final namaOk = _namaController.text.trim().isNotEmpty;
    final email = _emailController.text.trim();
    final emailOk = email.isNotEmpty && email.contains('@');
    final keluhanOk = _keluhanController.text.trim().isNotEmpty;
    return namaOk && emailOk && keluhanOk && _setujuSyarat && _modeTerpilih != null && _sesiTerpilih != null;
  }

  @override
  void initState() {
    super.initState();
    _namaController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _keluhanController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _keluhanController.dispose();
    super.dispose();
  }

  void _bersihkanFormulir() {
    setState(() {
      _namaController.clear();
      _emailController.clear();
      _keluhanController.clear();
      _kategoriTerpilih = 'Kecemasan';
      _modeTerpilih = 'Online (Video Call)';
      _sesiTerpilih = null;
      _setujuSyarat = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulir pendaftaran konseling telah dibersihkan.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _kirimPendaftaran() async {
    if (!_formLengkap || _sedangMengirim) return;

    setState(() => _sedangMengirim = true);

    // Simulasi pengiriman data pendaftaran konsultasi selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final idAcak = 'KTH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final sesiBaru = SesiKonsultasi(
      id: idAcak,
      namaPasien: _namaController.text.trim(),
      email: _emailController.text.trim(),
      namaPsikolog: widget.namaPsikolog,
      kategori: _kategoriTerpilih,
      mode: _modeTerpilih!,
      sesi: _sesiTerpilih!,
      tanggal: DateTime.now(),
      selesai: false,
      keluhan: _keluhanController.text.trim(),
    );

    // Simpan ke KonsultasiModel (Provider)
    context.read<KonsultasiModel>().tambah(sesiBaru);

    setState(() => _sedangMengirim = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.deepPurple.shade800,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Sesi konsultasi ($idAcak) dengan ${widget.namaPsikolog} berhasil dijadwalkan!',
              ),
            ),
          ],
        ),
      ),
    );

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = _emailController.text.trim();
    final emailError = email.isNotEmpty && !email.contains('@')
        ? 'Email wajib mengandung karakter @'
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Konsultasi Kutkatha'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bersihkanFormulir,
        tooltip: 'Reset formulir',
        child: const Icon(Icons.refresh),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Info Psikolog dengan GestureDetector
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(widget.namaPsikolog),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Spesialisasi: ${widget.spesialisasi}'),
                        const SizedBox(height: 8),
                        const Text(
                          'Psikolog berlisensi resmi HIMPSI dan terdaftar pada jaringan Kutkatha Kabupaten Kutai Kartanegara.',
                        ),
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
                    content: Text('Psikolog: ${widget.namaPsikolog} (${widget.spesialisasi})'),
                  ),
                );
              },
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.psychology, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.namaPsikolog,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                            ),
                            Text(
                              widget.spesialisasi,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Ketuk untuk detail lisensi, tahan untuk info singkat',
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.touch_app, size: 18, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // TextField Nama Pasien
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap Pasien *',
                hintText: 'Nama pemohon konsultasi',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // TextField Email / Kontak
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email / Kontak Pasien *',
                hintText: 'contoh: nama@kutkatha.id',
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
                errorText: emailError,
                helperText: 'Wajib mengandung tanda @ untuk konfirmasi jadwal',
              ),
            ),
            const SizedBox(height: 12),

            // Dropdown Kategori Masalah
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _kategoriTerpilih,
              decoration: const InputDecoration(
                labelText: 'Kategori Konsultasi *',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Kecemasan', child: Text('Kecemasan & Panik')),
                DropdownMenuItem(value: 'Stres Kuliah', child: Text('Stres Akademik / Pekerjaan')),
                DropdownMenuItem(value: 'Keluarga', child: Text('Hubungan & Keluarga')),
                DropdownMenuItem(value: 'Remaja', child: Text('Tumbuh Kembang Remaja')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _kategoriTerpilih = val);
              },
            ),
            const SizedBox(height: 12),

            // TextField Keluhan
            TextField(
              controller: _keluhanController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Singkat Keluhan / Tujuan Konseling *',
                hintText: 'Ceritakan apa yang sedang Anda rasakan atau butuhkan...',
                prefixIcon: Icon(Icons.edit_note),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // RadioButton Mode Konsultasi
            const Text(
              'Pilih Metode Konsultasi *',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Online (Video Call / Chat Terenkripsi)'),
                    subtitle: const Text('Fleksibel dari mana saja melalui Kutkatha Meet'),
                    value: 'Online (Video Call)',
                    groupValue: _modeTerpilih,
                    onChanged: (val) => setState(() => _modeTerpilih = val),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Tatap Muka (Klinik Tenggarong)'),
                    subtitle: const Text('Sesi langsung di ruang konseling mitra Kutkatha Kukar'),
                    value: 'Tatap Muka (Klinik)',
                    groupValue: _modeTerpilih,
                    onChanged: (val) => setState(() => _modeTerpilih = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // RadioButton Sesi Waktu
            const Text(
              'Pilih Sesi Waktu Konseling *',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Sesi Pagi (09.00 - 11.30 WITA)'),
                    value: 'Pagi',
                    groupValue: _sesiTerpilih,
                    onChanged: (val) => setState(() => _sesiTerpilih = val),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Sesi Siang (13.00 - 15.30 WITA)'),
                    value: 'Siang',
                    groupValue: _sesiTerpilih,
                    onChanged: (val) => setState(() => _sesiTerpilih = val),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Sesi Sore (16.00 - 18.00 WITA)'),
                    value: 'Sore',
                    groupValue: _sesiTerpilih,
                    onChanged: (val) => setState(() => _sesiTerpilih = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Checkbox Persetujuan Kode Etik & Kerahasiaan
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _setujuSyarat,
              title: const Text(
                'Saya menyetujui kode etik kerahasiaan konseling psikologi dan kebijakan privasi Kutkatha *',
                style: TextStyle(fontSize: 12.5),
              ),
              onChanged: (val) => setState(() => _setujuSyarat = val ?? false),
            ),
            const SizedBox(height: 16),

            // ElevatedButton Ajukan Pendaftaran
            ElevatedButton.icon(
              onPressed: (_formLengkap && !_sedangMengirim) ? _kirimPendaftaran : null,
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
                  : const Icon(Icons.event_available),
              label: Text(
                _sedangMengirim ? 'Menjadwalkan Konseling...' : 'Daftar Sesi Konsultasi',
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
