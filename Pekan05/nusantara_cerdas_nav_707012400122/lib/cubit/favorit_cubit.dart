import 'package:flutter_bloc/flutter_bloc.dart';

// FavoritCubit menyimpan kumpulan nama layanan yang ditandai favorit oleh
// warga. State berupa Set<String> agar satu layanan tidak tercatat dua kali.
//
// Sesuai materi Modul 5, state tidak diubah secara langsung (mutasi),
// melainkan diganti dengan salinan baru lalu dikirim melalui emit().
class FavoritCubit extends Cubit<Set<String>> {
  FavoritCubit() : super(<String>{});

  void tandai(String namaLayanan) {
    emit({...state, namaLayanan});
  }

  void batalTandai(String namaLayanan) {
    emit(state.where((nama) => nama != namaLayanan).toSet());
  }
}
