import 'package:flutter/material.dart';
import 'primary_button.dart';

class CartSummaryBar extends StatelessWidget {
  final int totalItem;
  final int totalHarga;
  final VoidCallback onKosongkan;
  final VoidCallback onCheckout;

  const CartSummaryBar({
    super.key,
    required this.totalItem,
    required this.totalHarga,
    required this.onKosongkan,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$totalItem item • Rp$totalHarga',
            style: theme.textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Kosongkan',
                  icon: Icons.delete_outline,
                  onPressed: onKosongkan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButton(
                  label: 'Checkout',
                  icon: Icons.check_circle_outline,
                  onPressed: onCheckout,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
