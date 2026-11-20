import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmbangBatas {
  final int waspadaAir;
  final int siagaAir;
  final int waspadaTanah;
  final int siagaTanah;
  final int waspadaHujan;
  final int siagaHujan;

  const AmbangBatas({
    this.waspadaAir = 100,
    this.siagaAir = 200,
    this.waspadaTanah = 15,
    this.siagaTanah = 30,
    this.waspadaHujan = 50,
    this.siagaHujan = 100,
  });
}

class PengaturanHelper {
  PengaturanHelper._();

  static const String kunciTemaGelap = 'tema_gelap';
  static const String kunciWaspadaAir = 'waspada_air';
  static const String kunciSiagaAir = 'siaga_air';
  static const String kunciWaspadaTanah = 'waspada_tanah';
  static const String kunciSiagaTanah = 'siaga_tanah';
  static const String kunciWaspadaHujan = 'waspada_hujan';
  static const String kunciSiagaHujan = 'siaga_hujan';

  static final ValueNotifier<AmbangBatas> ambangNotifier =
      ValueNotifier<AmbangBatas>(const AmbangBatas());

  static Future<bool> muatTemaGelap() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kunciTemaGelap) ?? false;
  }

  static Future<void> simpanTemaGelap(bool aktif) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kunciTemaGelap, aktif);
  }

  static Future<AmbangBatas> muatAmbangBatas() async {
    final prefs = await SharedPreferences.getInstance();
    final data = AmbangBatas(
      waspadaAir: prefs.getInt(kunciWaspadaAir) ?? 100,
      siagaAir: prefs.getInt(kunciSiagaAir) ?? 200,
      waspadaTanah: prefs.getInt(kunciWaspadaTanah) ?? 15,
      siagaTanah: prefs.getInt(kunciSiagaTanah) ?? 30,
      waspadaHujan: prefs.getInt(kunciWaspadaHujan) ?? 50,
      siagaHujan: prefs.getInt(kunciSiagaHujan) ?? 100,
    );
    ambangNotifier.value = data;
    return data;
  }

  static Future<void> simpanAmbangBatas(AmbangBatas ambang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kunciWaspadaAir, ambang.waspadaAir);
    await prefs.setInt(kunciSiagaAir, ambang.siagaAir);
    await prefs.setInt(kunciWaspadaTanah, ambang.waspadaTanah);
    await prefs.setInt(kunciSiagaTanah, ambang.siagaTanah);
    await prefs.setInt(kunciWaspadaHujan, ambang.waspadaHujan);
    await prefs.setInt(kunciSiagaHujan, ambang.siagaHujan);
    ambangNotifier.value = ambang;
  }

  static Future<void> resetSemua() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kunciTemaGelap);
    await prefs.remove(kunciWaspadaAir);
    await prefs.remove(kunciSiagaAir);
    await prefs.remove(kunciWaspadaTanah);
    await prefs.remove(kunciSiagaTanah);
    await prefs.remove(kunciWaspadaHujan);
    await prefs.remove(kunciSiagaHujan);
    ambangNotifier.value = const AmbangBatas();
  }
}
