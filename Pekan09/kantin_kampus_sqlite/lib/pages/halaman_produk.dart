import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../cubit/keranjang_cubit.dart';
import '../helpers/hive_helper.dart';
import '../models/produk.dart';
import '../models/produk_favorit.dart';
import '../widgets/product_card.dart';
import '../widgets/theme_toggle_button.dart';

class HalamanProduk extends StatelessWidget {
  const HalamanProduk({super.key});

  static const daftarProduk = [
    Produk(id: 'p1', nama: 'Nasi Goreng', harga: 15000),
    Produk(id: 'p2', nama: 'Es Teh Manis', harga: 5000),
    Produk(id: 'p3', nama: 'Ayam Geprek', harga: 18000),
  ];

  Future<void> simpanFavorit(Produk produk) async {
    final favorit = ProdukFavorit(
      idProduk: produk.id,
      nama: produk.nama,
      harga: produk.harga,
    );
    await HiveHelper.box.put(produk.id, favorit);
  }

  Widget _buildDaftar(BuildContext context, Box<ProdukFavorit>? box) {
    return ListView.builder(
      itemCount: daftarProduk.length,
      itemBuilder: (context, index) {
        final produk = daftarProduk[index];
        return ProductCard(
          produk: produk,
          isFavorit: box?.containsKey(produk.id) ?? false,
          onTambah: () => context.read<KeranjangCubit>().tambah(produk),
          onFavorit: () => simpanFavorit(produk),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final boxTerbuka = Hive.isBoxOpen(HiveHelper.namaBoxFavorit);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
        actions: const [ThemeToggleButton()],
      ),
      body: boxTerbuka
          ? ValueListenableBuilder<Box<ProdukFavorit>>(
              valueListenable: HiveHelper.box.listenable(),
              builder: (context, box, _) => _buildDaftar(context, box),
            )
          : _buildDaftar(context, null),
    );
  }
}
