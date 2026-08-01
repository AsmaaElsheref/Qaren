import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/localStorage/cache_helper.dart';
import '../../../../../core/localization/app_locales.dart';
import '../../../../../core/localization/locale_service.dart';

// ── Profile view-model ────────────────────────────────────────────────────────

class ProfileSettingsState {
  final String userName;
  final String accountSubtitle;
  final String? avatarUrl;
  final int unreadNotificationsCount;
  final bool isDarkMode;
  final bool isArabic;
  final String appVersion;

  const ProfileSettingsState({
    required this.userName,
    required this.accountSubtitle,
    this.avatarUrl,
    required this.unreadNotificationsCount,
    required this.isDarkMode,
    required this.isArabic,
    required this.appVersion,
  });

  ProfileSettingsState copyWith({
    String? userName,
    String? accountSubtitle,
    String? avatarUrl,
    int? unreadNotificationsCount,
    bool? isDarkMode,
    bool? isArabic,
    String? appVersion,
  }) {
    return ProfileSettingsState(
      userName: userName ?? this.userName,
      accountSubtitle: accountSubtitle ?? this.accountSubtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadNotificationsCount:
          unreadNotificationsCount ?? this.unreadNotificationsCount,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isArabic: isArabic ?? this.isArabic,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ProfileSettingsNotifier extends Notifier<ProfileSettingsState> {
  @override
  ProfileSettingsState build() {
    final cachedUserName =
        (CacheHelper.getData(key: AppConstants.userName) as String?)?.trim();
    final cachedEmail =
        (CacheHelper.getData(key: AppConstants.userEmail) as String?)?.trim();
    final savedDarkMode =
        CacheHelper.getData(key: AppConstants.isDarkMode) as bool? ?? false;

    final savedLocale = LocaleService.readSavedLocale();
    return ProfileSettingsState(
      userName: cachedUserName?.isNotEmpty == true
          ? cachedUserName!
          : 'profile.defaultUserName'.tr(),
      accountSubtitle: cachedEmail?.isNotEmpty == true
          ? cachedEmail!
          : 'profile.accountLabel'.tr(),
      avatarUrl: null,
      unreadNotificationsCount: 3,
      isDarkMode: savedDarkMode,
      isArabic: AppLocales.isArabic(savedLocale),
      appVersion: '2.0',
    );
  }

  void toggleDarkMode() {
    final newValue = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newValue);
    CacheHelper.saveData(key: AppConstants.isDarkMode, value: newValue);
  }

  void toggleLanguage() {
    state = state.copyWith(isArabic: !state.isArabic);
  }

  void syncLocale(Locale locale) {
    state = state.copyWith(isArabic: AppLocales.isArabic(locale));
  }

  void clearNotifications() {
    state = state.copyWith(unreadNotificationsCount: 0);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final profileSettingsProvider =
    NotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>(
      ProfileSettingsNotifier.new,
    );

// ── Granular selectors (minimize rebuilds) ────────────────────────────────────

final profileIsDarkModeProvider = Provider<bool>(
  (ref) => ref.watch(profileSettingsProvider.select((s) => s.isDarkMode)),
);

final profileIsArabicProvider = Provider<bool>(
  (ref) => ref.watch(profileSettingsProvider.select((s) => s.isArabic)),
);

final profileUnreadCountProvider = Provider<int>(
  (ref) => ref.watch(
    profileSettingsProvider.select((s) => s.unreadNotificationsCount),
  ),
);

final profileUserNameProvider = Provider<String>(
  (ref) => ref.watch(profileSettingsProvider.select((s) => s.userName)),
);
