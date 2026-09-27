import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/localization/locale_service.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../home/presentation/providers/navigation_data_refresher.dart';
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
      label: 'profile.menu.languageWithValue'.tr(
        namedArgs: {
          'language': isArabic
              ? 'profile.language.arabic'.tr()
              : 'profile.language.english'.tr(),
        },
      ),
      value: isArabic,
      onChanged: (_) async {
        final currentIndex = ref.read(bottomNavIndexProvider);
        final dataRefresher = ref.read(navigationDataRefresherProvider);

        await LocaleService.toggleLocale(context);
        dataRefresher.refreshAfterLocaleChange(currentIndex);
      },
    );
  }
}
