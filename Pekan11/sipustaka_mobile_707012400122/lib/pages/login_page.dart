import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_layout.dart';
import '../widgets/gradient_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await context.read<AuthCubit>().login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Masuk SiPustaka',
      subtitle: 'Login untuk mengelola katalog dan peminjaman buku',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi';
                }
                if (!value.contains('@')) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 26),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return GradientButton(
                  text: 'Login',
                  icon: Icons.login_rounded,
                  isLoading: state.isLoading,
                  onPressed: _login,
                );
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Belum punya akun?',
                  style: TextStyle(color: AppColors.textGrey),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: const Text(
                    'Daftar',
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
