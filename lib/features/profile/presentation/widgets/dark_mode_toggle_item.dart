import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profileSettings/profile_settings_provider.dart';
import 'settings_toggle_item.dart';

class DarkModeToggleItem extends ConsumerWidget {
  const DarkModeToggleItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when isDarkMode changes
    final isDarkMode = ref.watch(profileIsDarkModeProvider);

    return SettingsToggleItem(
      icon: Icons.dark_mode_outlined,
      iconColor: const Color(0xFF7C3AED),
      iconBackground: const Color(0xFFF3EEFF),
      label: 'الوضع الليلي',
      value: isDarkMode,
      onChanged: (_) =>
          ref.read(profileSettingsProvider.notifier).toggleDarkMode(),
    );
  }
}

