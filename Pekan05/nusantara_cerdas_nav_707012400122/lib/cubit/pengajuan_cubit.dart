import 'package:flutter_bloc/flutter_bloc.dart';
import 'pengajuan_state.dart';

class PengajuanCubit extends Cubit<PengajuanState> {
  PengajuanCubit() : super(const PengajuanState([]));

  void ajukan(String namaLayanan) {
    if (state.daftarLayanan.contains(namaLayanan)) return;
    emit(PengajuanState([...state.daftarLayanan, namaLayanan]));
  }

  void batalkan(String namaLayanan) {
    emit(PengajuanState(
      state.daftarLayanan.where((nama) => nama != namaLayanan).toList(),
    ));
  }

  void kirimSemua() {
    emit(const PengajuanState([]));
  }
}
