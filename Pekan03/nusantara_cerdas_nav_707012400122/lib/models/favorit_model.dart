// lib/models/favorit_model.dart
import 'package:flutter/foundation.dart';

class FavoritModel extends ChangeNotifier {
  final Set<String> _namaFavorit = {};

  Set<String> get namaFavorit => Set.unmodifiable(_namaFavorit);

  int get totalFavorit => _namaFavorit.length;

  bool apakahFavorit(String namaLayanan) => _namaFavorit.contains(namaLayanan);

  void tandai(String namaLayanan) {
    // add() mengembalikan false jika nama sudah ada, sehingga tidak perlu notifikasi.
    if (_namaFavorit.add(namaLayanan)) {
      notifyListeners();
    }
  }

  void batalTandai(String namaLayanan) {
    if (_namaFavorit.remove(namaLayanan)) {
      notifyListeners();
    }
  }
}
