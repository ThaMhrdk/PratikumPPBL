class PengajuanState {
  const PengajuanState(this.daftarLayanan);

  final List<String> daftarLayanan;

  int get totalPengajuan => daftarLayanan.length;
}
