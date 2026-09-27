import 'package:flutter/material.dart';
import 'package:qaren/core/localization/easy_localization.dart';

class LocalizedFormatters {
  LocalizedFormatters._();

  static String dateTime(BuildContext context, String? rawValue) {
    final value = rawValue?.trim();
    if (value == null || value.isEmpty) return '';

    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;

    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMd(locale).add_jm().format(parsed.toLocal());
  }

  static String date(BuildContext context, DateTime value) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMd(locale).format(value.toLocal());
  }

  static String time(BuildContext context, DateTime value) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.jm(locale).format(value.toLocal());
  }

  static String number(BuildContext context, num value, {int decimals = 0}) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimals,
    ).format(value);
  }

  /// The application operates in Saudi Riyals. Keep the API currency code
  /// language-neutral and localize only its user-facing representation.
  static String currency(BuildContext context) => context.tr('common.currency');
}
