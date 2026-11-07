import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/theme_cubit.dart';

class SakelarTema extends StatelessWidget {
  const SakelarTema({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;

    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.secondaryContainer
                : theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            color: isDark
                ? theme.colorScheme.onSecondaryContainer
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          'Mode Tampilan',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isDark ? 'Mode Gelap (Dark Mode)' : 'Mode Terang (Light Mode)',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Switch(
          value: isDark,
          activeTrackColor: theme.colorScheme.primary,
          activeThumbColor: theme.colorScheme.onPrimary,
          onChanged: (val) {
            context.read<ThemeCubit>().toggle();
          },
        ),
      ),
    );
  }
}
