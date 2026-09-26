import 'package:flutter/material.dart';
import 'halaman_utama.dart';

void main() {
  runApp(const AplikasiNusantaraCerdas());
}

class AplikasiNusantaraCerdas extends StatelessWidget {
  const AplikasiNusantaraCerdas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusantara Cerdas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const HalamanUtama(),
    );
  }
}
