import 'package:flutter/material.dart';

/// TombolUtama adalah Custom Reusable Widget tombol aksi yang mengadopsi
/// gaya visual dari elevatedButtonTheme atau filledButtonTheme pada AppTheme.
class TombolUtama extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFilled;
  final bool isOutlined;
  final bool isFullWidth;

  const TombolUtama({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFilled = true,
    this.isOutlined = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;
    if (isOutlined) {
      button = icon != null
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
            )
          : OutlinedButton(
              onPressed: onPressed,
              child: Text(label),
            );
    } else if (isFilled) {
      button = icon != null
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
            )
          : FilledButton(
              onPressed: onPressed,
              child: Text(label),
            );
    } else {
      button = icon != null
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
            )
          : ElevatedButton(
              onPressed: onPressed,
              child: Text(label),
            );
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    return button;
  }
}
