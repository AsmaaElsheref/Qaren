import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profileSettings/profile_settings_provider.dart';
import 'settings_toggle_item.dart';

class DarkModeToggleItem extends ConsumerWidget {
  const DarkModeToggleItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the locale explicitly so this item rebuilds immediately when the
    // language changes while the drawer is still open.
    final localeCode = context.locale.languageCode;
    final isDarkMode = ref.watch(profileIsDarkModeProvider);

    return SettingsToggleItem(
      key: ValueKey('dark-mode-setting-$localeCode'),
      icon: Icons.dark_mode_outlined,
      iconColor: const Color(0xFF7C3AED),
      iconBackground: const Color(0xFFF3EEFF),
      label: 'profile.menu.darkMode'.tr(),
      value: isDarkMode,
      onChanged: (_) =>
          ref.read(profileSettingsProvider.notifier).toggleDarkMode(),
    );
  }
}
