import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profileSettings/profile_settings_provider.dart';
import 'settings_toggle_item.dart';

class LanguageToggleItem extends ConsumerWidget {
  const LanguageToggleItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when isArabic changes
    final isArabic = ref.watch(profileIsArabicProvider);

    return SettingsToggleItem(
      icon: Icons.language_rounded,
      iconColor: const Color(0xFF27AAE1),
      iconBackground: const Color(0xFFE8F4FD),
      label: 'لغة التطبيق',
      value: isArabic,
      onChanged: (_) =>
          ref.read(profileSettingsProvider.notifier).toggleLanguage(),
    );
  }
}

