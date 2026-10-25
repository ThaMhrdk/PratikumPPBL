import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(const BookingState([]));

  // Menambahkan booking konsultasi baru. Satu psikolog hanya dapat dibooking satu kali.
  void tambahBooking({
    required String namaPsikolog,
    required String spesialisasi,
    required String jadwal,
  }) {
    if (state.sudahDibooking(namaPsikolog)) return;
    emit(BookingState([
      ...state.daftarBooking,
      ItemBooking(
        namaPsikolog: namaPsikolog,
        spesialisasi: spesialisasi,
        jadwal: jadwal,
      ),
    ]));
  }

  // Membatalkan booking konsultasi berdasarkan nama psikolog.
  void batalkanBooking(String namaPsikolog) {
    emit(BookingState(
      state.daftarBooking
          .where((item) => item.namaPsikolog != namaPsikolog)
          .toList(),
    ));
  }
}
