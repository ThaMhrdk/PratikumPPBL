import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/pengajuan_cubit.dart';
import '../widgets/tombol_favorit.dart';

// Diubah dari StatelessWidget (Modul II) menjadi StatefulWidget, karena
// halaman ini sekarang menyimpan state lokal _sedangMengirim.
class HalamanRincianLayanan extends StatefulWidget {
  const HalamanRincianLayanan({
    super.key,
    required this.namaLayanan,
    required this.dinas,
    required this.jamOperasional,
    required this.keterangan,
  });

  final String namaLayanan;
  final String dinas;
  final String jamOperasional;
  final String keterangan;

  @override
  State<HalamanRincianLayanan> createState() => _HalamanRincianLayananState();
}

class _HalamanRincianLayananState extends State<HalamanRincianLayanan> {
  // State LOKAL: status sedang mengirim hanya penting bagi tombol pada
  // halaman ini dan langsung hilang ketika halaman ditutup, sehingga cukup
  // dikelola dengan setState(), tidak perlu Cubit.
  bool _sedangMengirim = false;

  Future<void> _ajukanPermohonan() async {
    setState(() {
      _sedangMengirim = true;
    });

    // Simulasi proses pengiriman permohonan ke server dinas.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    // Setelah proses selesai, layanan dimasukkan ke keranjang pengajuan.
    // context.read() dipakai karena di sini hanya memanggil method,
    // bukan membaca state untuk ditampilkan.
    context.read<PengajuanCubit>().ajukan(widget.namaLayanan);

    // Nilai balik tetap dikirim melalui Navigator.pop seperti pada Modul II,
    // lalu ditampilkan sebagai SnackBar oleh halaman Layanan.
    Navigator.pop(
      context,
      'Permohonan ${widget.namaLayanan} ditambahkan ke daftar pengajuan.',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold sendiri, sebab halaman ini dibuka sebagai halaman penuh
    // melalui named route dan memerlukan AppBar beserta tombol kembali.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaLayanan),
        actions: [TombolFavorit(namaLayanan: widget.namaLayanan)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.namaLayanan,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buatBarisInfo(Icons.apartment, 'Dinas Penanggung Jawab', widget.dinas),
            const SizedBox(height: 12),
            _buatBarisInfo(Icons.schedule, 'Jam Operasional', widget.jamOperasional),
            const SizedBox(height: 12),
            _buatBarisInfo(Icons.info_outline, 'Keterangan', widget.keterangan),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                // Tombol dinonaktifkan selama mengirim agar warga tidak
                // menekan tombol berulang kali.
                onPressed: _sedangMengirim ? null : _ajukanPermohonan,
                icon: _sedangMengirim
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_outlined),
                label: Text(
                  _sedangMengirim ? 'Sedang mengirim...' : 'Ajukan Permohonan',
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _sedangMengirim ? null : () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buatBarisInfo(IconData ikon, String label, String isi) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ikon, size: 20, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(isi, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
