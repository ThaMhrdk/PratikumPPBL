import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

// Diubah dari StatelessWidget (Modul II) menjadi StatefulWidget karena
// halaman ini sekarang memiliki state lokal _sedangMemproses.
class HalamanDetailPsikolog extends StatefulWidget {
  const HalamanDetailPsikolog({
    super.key,
    required this.nama,
    required this.spesialisasi,
    required this.jadwal,
    required this.keterangan,
  });

  final String nama;
  final String spesialisasi;
  final String jadwal;
  final String keterangan;

  @override
  State<HalamanDetailPsikolog> createState() => _HalamanDetailPsikologState();
}

class _HalamanDetailPsikologState extends State<HalamanDetailPsikolog> {
  // State LOKAL (setState): status memproses booking hanya penting bagi
  // tombol pada halaman ini dan tidak perlu diketahui halaman lain.
  bool _sedangMemproses = false;

  Future<void> _ajukanBooking() async {
    setState(() {
      _sedangMemproses = true;
    });

    // Simulasi proses pengiriman booking ke server Kutkatha.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    // State BERSAMA (Cubit): memanggil method tambahBooking() pada BookingCubit.
    // context.read() dipakai karena di sini hanya mengirim aksi.
    context.read<BookingCubit>().tambahBooking(
          namaPsikolog: widget.nama,
          spesialisasi: widget.spesialisasi,
          jadwal: widget.jadwal,
        );

    // Nilai balik tetap dikirim melalui Navigator.pop seperti pada Modul II.
    Navigator.pop(
      context,
      'Booking konsultasi dengan ${widget.nama} berhasil diajukan.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rincian Psikolog')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.person, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              widget.nama,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buatBarisInfo(
                Icons.psychology_alt_outlined, 'Spesialisasi', widget.spesialisasi),
            const SizedBox(height: 12),
            _buatBarisInfo(Icons.schedule, 'Jadwal Praktik', widget.jadwal),
            const SizedBox(height: 12),
            _buatBarisInfo(Icons.info_outline, 'Keterangan', widget.keterangan),
            const Spacer(),
            // BlocSelector hanya memilih status "sudah dibooking" untuk
            // psikolog ini, sehingga hanya tombol yang dibangun ulang.
            BlocSelector<BookingCubit, BookingState, bool>(
              selector: (state) => state.sudahDibooking(widget.nama),
              builder: (context, sudahDibooking) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        (_sedangMemproses || sudahDibooking) ? null : _ajukanBooking,
                    icon: _sedangMemproses
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(sudahDibooking
                            ? Icons.check_circle_outline
                            : Icons.event_available_outlined),
                    label: Text(
                      _sedangMemproses
                          ? 'Sedang memproses...'
                          : sudahDibooking
                              ? 'Sudah Dibooking'
                              : 'Ajukan Booking Konsultasi',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _sedangMemproses ? null : () => Navigator.pop(context),
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
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text(isi, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
