import 'package:flutter/material.dart';

/// Supported locales and paths for [easy_localization].
class AppLocales {
  AppLocales._();

  static const translationsPath = 'assets/translations';

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const fallbackLocale = Locale('en');
  static const defaultLocale = Locale('ar');

  static bool isArabic(Locale locale) => locale.languageCode == 'ar';
}
