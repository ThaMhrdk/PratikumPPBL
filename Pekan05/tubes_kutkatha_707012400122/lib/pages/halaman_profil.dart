import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../navigation/app_routes.dart';

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  @override
  Widget build(BuildContext context) {
    // Tanpa Scaffold, sebab halaman ini tampil di dalam Scaffold
    // milik KerangkaNavigasi.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        const SizedBox(height: 12),
        const Center(child: Text('Muhammad Anantha Mahardika Ridwan')),
        const Center(child: Text('Warga Kutai Kartanegara')),
        const SizedBox(height: 24),
        const Text(
          'Booking Konsultasi Saya',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Daftar booking yang diajukan dari halaman Rincian Psikolog.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        // BlocBuilder: seluruh daftar booking perlu digambar ulang setiap
        // kali booking ditambah atau dibatalkan.
        BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state.daftarBooking.isEmpty) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.event_busy_outlined),
                  title: const Text('Belum ada booking konsultasi'),
                  subtitle: const Text('Pilih psikolog lalu ajukan booking.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.psikologList),
                ),
              );
            }
            return Card(
              child: Column(
                children: [
                  for (final item in state.daftarBooking)
                    ListTile(
                      leading: const Icon(Icons.event_available),
                      title: Text(item.namaPsikolog),
                      subtitle: Text('${item.spesialisasi}\n${item.jadwal}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        tooltip: 'Batalkan booking',
                        icon: const Icon(Icons.cancel_outlined),
                        // context.read(): hanya memanggil method Cubit, tidak
                        // mendengarkan perubahan state.
                        onPressed: () => context
                            .read<BookingCubit>()
                            .batalkanBooking(item.namaPsikolog),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Pengaturan'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.pengaturan),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Tentang Aplikasi'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.tentangAplikasi),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Keluar'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.keluar),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
