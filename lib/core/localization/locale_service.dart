import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../localStorage/cache_helper.dart';
import 'app_locales.dart';

/// Persists and switches the app locale.
class LocaleService {
  LocaleService._();

  static Locale readSavedLocale() {
    final code = CacheHelper.getData(key: AppConstants.languageCode) as String?;
    if (code == null) return AppLocales.defaultLocale;
    return Locale(code);
  }

  static Future<void> saveLocale(Locale locale) async {
    await CacheHelper.saveData(
      key: AppConstants.languageCode,
      value: locale.languageCode,
    );
  }

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
    await saveLocale(locale);
  }
}
