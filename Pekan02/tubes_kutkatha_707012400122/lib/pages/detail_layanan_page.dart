import 'package:flutter/material.dart';

class DetailLayananPage extends StatelessWidget {
  const DetailLayananPage({required this.serviceName, super.key});

  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceName)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.psychology_alt, size: 56, color: Colors.teal),
            const SizedBox(height: 20),
            Text(
              'Detail layanan $serviceName',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              'Halaman ini menjadi contoh detail yang menerima data melalui '
              'named route dan mengirim hasil kembali saat tombol dipilih.',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, serviceName),
                child: const Text('Pilih layanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
