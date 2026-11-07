import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HalamanPetaKlinik extends StatefulWidget {
  const HalamanPetaKlinik({super.key});

  @override
  State<HalamanPetaKlinik> createState() => _HalamanPetaKlinikState();
}

class _HalamanPetaKlinikState extends State<HalamanPetaKlinik> {
  // Titik koordinat pusat Tenggarong, Kutai Kartanegara
  static const LatLng _pusatTenggarong = LatLng(-0.4280, 116.9920);

  // Penanda fasilitas layanan psikologi mitra Kutkatha di Kukar
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('klinik_kutkatha_pusat'),
      position: LatLng(-0.4280, 116.9920),
      infoWindow: InfoWindow(
        title: 'Pusat Konseling Kutkatha',
        snippet: 'Jl. Wolter Monginsidi No. 18, Tenggarong',
      ),
    ),
    const Marker(
      markerId: MarkerId('rsud_parikesit'),
      position: LatLng(-0.4350, 116.9850),
      infoWindow: InfoWindow(
        title: 'Poli Jiwa RSUD AM Parikesit',
        snippet: 'Jl. Ratu Agung No. 1, Tenggarong Seberang',
      ),
    ),
    const Marker(
      markerId: MarkerId('klinik_keluarga_kukar'),
      position: LatLng(-0.4220, 116.9980),
      infoWindow: InfoWindow(
        title: 'Klinik Ramah Remaja & Keluarga',
        snippet: 'Jl. Pesut No. 5, Timbau, Tenggarong',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: _pusatTenggarong,
        zoom: 14.5,
      ),
      markers: _markers,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
    );
  }
}
