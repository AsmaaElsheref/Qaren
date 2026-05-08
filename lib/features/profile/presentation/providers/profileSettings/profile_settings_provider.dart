import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/localStorage/cache_helper.dart';
import '../../../../../core/constants/app_constants.dart';

// ── Profile view-model ────────────────────────────────────────────────────────

class ProfileSettingsState {
  final String userName;
  final String membershipLabel;
  final String? avatarUrl;
  final int unreadNotificationsCount;
  final bool isDarkMode;
  final bool isArabic;
  final String appVersion;

  const ProfileSettingsState({
    required this.userName,
    required this.membershipLabel,
    this.avatarUrl,
    required this.unreadNotificationsCount,
    required this.isDarkMode,
    required this.isArabic,
    required this.appVersion,
  });

  ProfileSettingsState copyWith({
    String? userName,
    String? membershipLabel,
    String? avatarUrl,
    int? unreadNotificationsCount,
    bool? isDarkMode,
    bool? isArabic,
    String? appVersion,
  }) {
    return ProfileSettingsState(
      userName: userName ?? this.userName,
      membershipLabel: membershipLabel ?? this.membershipLabel,
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
    final cached =
        CacheHelper.getData(key: AppConstants.userName) as String?;
    return ProfileSettingsState(
      userName: cached ?? 'المستخدم',
      membershipLabel: 'عضو ذهبي',
      avatarUrl: null,
      unreadNotificationsCount: 3,
      isDarkMode: false,
      isArabic: true,
      appVersion: '2.0',
    );
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void toggleLanguage() {
    state = state.copyWith(isArabic: !state.isArabic);
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
  (ref) => ref.watch(
    profileSettingsProvider.select((s) => s.isDarkMode),
  ),
);

final profileIsArabicProvider = Provider<bool>(
  (ref) => ref.watch(
    profileSettingsProvider.select((s) => s.isArabic),
  ),
);

final profileUnreadCountProvider = Provider<int>(
  (ref) => ref.watch(
    profileSettingsProvider.select((s) => s.unreadNotificationsCount),
  ),
);

final profileUserNameProvider = Provider<String>(
  (ref) => ref.watch(
    profileSettingsProvider.select((s) => s.userName),
  ),
);

