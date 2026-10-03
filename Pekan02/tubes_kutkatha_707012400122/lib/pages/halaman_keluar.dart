import 'package:flutter/material.dart';

class HalamanKeluar extends StatelessWidget {
  const HalamanKeluar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keluar')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, size: 56, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text(
                'Apakah Anda yakin ingin keluar dari aplikasi Kutkatha?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Pada perangkat sungguhan, SystemNavigator.pop() dari
                      // 'package:flutter/services.dart' dapat dipakai untuk
                      // benar-benar menutup aplikasi.
                      Navigator.pop(context);
                    },
                    child: const Text('Ya, Keluar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
