import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_locales.dart';

/// Single entry point for changing the app locale.
///
/// Persistence and first-launch device-locale detection are handled by
/// [EasyLocalization].
class LocaleService {
  LocaleService._();

  static Future<void> setArabic(BuildContext context) async {
    await _setLocale(context, const Locale('ar'));
  }

  static Future<void> setEnglish(BuildContext context) async {
    await _setLocale(context, const Locale('en'));
  }

  static Future<void> toggleLocale(BuildContext context) async {
    final next = AppLocales.isArabic(context.locale)
        ? const Locale('en')
        : const Locale('ar');
    await _setLocale(context, next);
  }

  static Future<void> _setLocale(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    Intl.defaultLocale = locale.toLanguageTag();
  }
}
