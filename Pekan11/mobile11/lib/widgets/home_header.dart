import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/user.dart';

/// Header berwarna gradasi di halaman utama.
/// Berisi sapaan, tombol login / foto profil, dan statistik.
class HomeHeader extends StatelessWidget {
  final User? user; // null = belum login
  final bool isChecking; // sedang cek login
  final int totalPost;
  final int myPost;
  final VoidCallback onLoginTap;
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.user,
    required this.isChecking,
    required this.totalPost,
    required this.myPost,
    required this.onLoginTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top; // tinggi status bar
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, topPadding + 20, 24, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Sapaan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user == null ? 'Halo, Tamu 👋' : 'Halo, ${user!.name} 👋',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Yuk baca dan tulis artikel hari ini',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Tombol Login atau foto profil
              if (!isChecking)
                user == null ? _loginButton() : _profileButton(),
            ],
          ),
          const SizedBox(height: 24),
          // Statistik
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.article_rounded,
                  value: '$totalPost',
                  label: 'Total Post',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  icon: Icons.edit_note_rounded,
                  value: user == null ? '-' : '$myPost',
                  label: 'Post Saya',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return ElevatedButton.icon(
      onPressed: onLoginTap,
      icon: const Icon(Icons.login_rounded, size: 18),
      label: const Text('Login'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        shape: const StadiumBorder(),
      ),
    );
  }

  Widget _profileButton() {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Text(
            user!.name.isEmpty ? '?' : user!.name[0].toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Kotak kecil statistik di header
class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
