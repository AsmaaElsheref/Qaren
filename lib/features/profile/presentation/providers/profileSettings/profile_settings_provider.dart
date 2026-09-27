import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/localStorage/cache_helper.dart';

// ── Profile view-model ────────────────────────────────────────────────────────

class ProfileSettingsState {
  final String userName;
  final String? avatarUrl;
  final int unreadNotificationsCount;
  final bool isDarkMode;
  final String appVersion;

  const ProfileSettingsState({
    required this.userName,
    this.avatarUrl,
    required this.unreadNotificationsCount,
    required this.isDarkMode,
    required this.appVersion,
  });

  ProfileSettingsState copyWith({
    String? userName,
    String? avatarUrl,
    int? unreadNotificationsCount,
    bool? isDarkMode,
    String? appVersion,
  }) {
    return ProfileSettingsState(
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadNotificationsCount:
          unreadNotificationsCount ?? this.unreadNotificationsCount,
      isDarkMode: isDarkMode ?? this.isDarkMode,
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
    final savedDarkMode =
        CacheHelper.getData(key: AppConstants.isDarkMode) as bool? ?? false;

    return ProfileSettingsState(
      userName: cachedUserName?.isNotEmpty == true ? cachedUserName! : '',
      avatarUrl: null,
      unreadNotificationsCount: 3,
      isDarkMode: savedDarkMode,
      appVersion: '2.0',
    );
  }

  void toggleDarkMode() {
    final newValue = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newValue);
    CacheHelper.saveData(key: AppConstants.isDarkMode, value: newValue);
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

final profileUnreadCountProvider = Provider<int>(
  (ref) => ref.watch(
    profileSettingsProvider.select((s) => s.unreadNotificationsCount),
  ),
);

final profileUserNameProvider = Provider<String>(
  (ref) => ref.watch(profileSettingsProvider.select((s) => s.userName)),
);
