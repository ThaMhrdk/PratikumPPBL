import 'package:flutter/material.dart';
import '../models/produk.dart';

class ProductCard extends StatelessWidget {
  final Produk produk;
  final VoidCallback onTambah;
  final VoidCallback onFavorit;
  final bool isFavorit;

  const ProductCard({
    super.key,
    required this.produk,
    required this.onTambah,
    required this.onFavorit,
    this.isFavorit = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        title: Text(
          produk.nama,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          'Rp${produk.harga}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorit ? Icons.favorite : Icons.favorite_border,
                color: isFavorit ? Colors.red : null,
              ),
              tooltip: 'Tandai favorit',
              onPressed: onFavorit,
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
              onPressed: onTambah,
            ),
          ],
        ),
      ),
    );
  }
}
