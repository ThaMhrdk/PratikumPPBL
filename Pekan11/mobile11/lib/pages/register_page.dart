import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_layout.dart';
import '../widgets/gradient_button.dart';

// ============================================================
// HALAMAN REGISTRASI  (POST /api/auth/register)
// ============================================================
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await context.read<AuthCubit>().register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
    // Jika berhasil, kembali ke halaman login
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Buat Akun Baru ✨',
      subtitle: 'Isi data di bawah untuk mendaftar',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                if (value.length > 100) return 'Nama maksimal 100 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi';
                }
                if (!value.contains('@')) return 'Format email salah';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              label: 'Password (min. 8 karakter)',
              icon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Password minimal 8 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return GradientButton(
                  text: 'Daftar',
                  icon: Icons.person_add_alt_1_rounded,
                  isLoading: state.isLoading,
                  onPressed: _register,
                );
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Sudah punya akun?',
                    style: TextStyle(color: AppColors.textGrey)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
