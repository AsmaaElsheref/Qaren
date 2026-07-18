import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/localization/locale_service.dart';
import '../providers/profileSettings/profile_settings_provider.dart';
import 'settings_toggle_item.dart';

class LanguageToggleItem extends ConsumerWidget {
  const LanguageToggleItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = context.locale.languageCode == 'ar';

    return SettingsToggleItem(
      icon: Icons.language_rounded,
      iconColor: const Color(0xFF27AAE1),
      iconBackground: const Color(0xFFE8F4FD),
      label: 'profile.menu.language'.tr(),
      value: isArabic,
      onChanged: (_) async {
        final nextLocale = isArabic ? const Locale('en') : const Locale('ar');
        await context.setLocale(nextLocale);
        await LocaleService.saveLocale(nextLocale);
        ref.read(profileSettingsProvider.notifier).syncLocale(nextLocale);
      },
    );
  }
}
