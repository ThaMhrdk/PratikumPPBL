import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final isMultiLine = widget.maxLines > 1;
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      obscureText: widget.isPassword && _hidePassword,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.label,
        alignLabelWithHint: isMultiLine,
        prefixIcon: isMultiLine
            ? null
            : Icon(widget.icon, color: AppColors.primary),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textGrey,
                ),
                onPressed: () {
                  setState(() => _hidePassword = !_hidePassword);
                },
              )
            : null,
      ),
    );
  }
}
