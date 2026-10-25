class ItemBooking {
  const ItemBooking({
    required this.namaPsikolog,
    required this.spesialisasi,
    required this.jadwal,
  });

  final String namaPsikolog;
  final String spesialisasi;
  final String jadwal;
}

class BookingState {
  const BookingState(this.daftarBooking);

  final List<ItemBooking> daftarBooking;

  int get totalBooking => daftarBooking.length;

  bool sudahDibooking(String namaPsikolog) =>
      daftarBooking.any((item) => item.namaPsikolog == namaPsikolog);
}
