import 'package:flutter/material.dart';

class HalamanKeluar extends StatelessWidget {
  const HalamanKeluar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Keluar')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                size: 56,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Apakah Anda yakin ingin keluar dari aplikasi Nusantara Cerdas Mobile?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    ),
                    onPressed: () {
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
