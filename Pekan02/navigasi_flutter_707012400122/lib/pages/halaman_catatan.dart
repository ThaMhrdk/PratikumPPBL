// lib/pages/halaman_catatan.dart (berkas BARU)
import 'package:flutter/material.dart';

class HalamanCatatan extends StatelessWidget {
  const HalamanCatatan({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan')),
      body: const Center(child: Text('Daftar catatan kuliah')),
      // tombol melayang yang menempel pada cekungan bilah
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Tambah catatan baru')));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // BottomAppBar berisi aksi, bukan tujuan navigasi
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
            const SizedBox(width: 40),
            IconButton(icon: const Icon(Icons.sort), onPressed: () {}),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
