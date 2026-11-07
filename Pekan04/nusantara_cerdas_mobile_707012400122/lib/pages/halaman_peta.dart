import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HalamanPeta extends StatefulWidget {
  const HalamanPeta({super.key});

  @override
  State<HalamanPeta> createState() => _HalamanPetaState();
}

class _HalamanPetaState extends State<HalamanPeta> {
  // Titik koordinat pusat Kawasan Inti Balai Kota Nusantara
  static const LatLng _pusatBalaiKota = LatLng(-0.9723, 116.7088);

  // Minimal 3 penanda kantor layanan sesuai ketentuan Modul 4
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('balai_kota'),
      position: LatLng(-0.9723, 116.7088),
      infoWindow: InfoWindow(
        title: 'Balai Kota Nusantara',
        snippet: 'Pusat Pemerintahan & Layanan Terpadu',
      ),
    ),
    const Marker(
      markerId: MarkerId('disdukcapil'),
      position: LatLng(-0.9660, 116.7150),
      infoWindow: InfoWindow(
        title: 'Kantor Disdukcapil Nusantara',
        snippet: 'Layanan KTP Digital & Kependudukan',
      ),
    ),
    const Marker(
      markerId: MarkerId('dinkes'),
      position: LatLng(-0.9785, 116.7020),
      infoWindow: InfoWindow(
        title: 'Dinas Kesehatan Nusantara',
        snippet: 'Pusat Rujukan Medis & BPJS Smart',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: _pusatBalaiKota,
        zoom: 14.5,
      ),
      markers: _markers,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
    );
  }
}
