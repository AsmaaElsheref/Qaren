import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/features/profile/presentation/pages/personalProfile/personal_profile_page.dart';
import '../../../../auth/presentation/pages/login_page.dart';
import '../../../../auth/presentation/providers/login_providers.dart';
import '../../widgets/dark_mode_toggle_item.dart';
import '../../widgets/language_toggle_item.dart';
import '../../widgets/logout_confirmation_sheet.dart';
import '../../providers/profileSettings/profile_settings_provider.dart';
import '../../widgets/app_version_text.dart';
import '../../widgets/logout_menu_item.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/settings_section_title.dart';
import '../../widgets/settings_menu_item.dart';
import '../../widgets/delete_account_confirmation_sheet.dart';
import '../../widgets/delete_account_menu_item.dart';
import '../../../../../core/theme/app_color_tokens.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_colors_ext.dart';
import '../legal/privacy_policy_webview_page.dart';
import '../legal/terms_of_use_page.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  void _openPrivacyPolicy(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute(builder: (_) => const PrivacyPolicyWebViewPage()),
    );
  }

  void _openTermsOfUse(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(MaterialPageRoute(builder: (_) => const TermsOfUsePage()));
  }

  Future<void> _showLogoutSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => LogoutConfirmationSheet(
        onConfirm: () => _performLogout(context, ref),
      ),
    );
  }

  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    await ref.read(loginNotifierProvider.notifier).logout();
    ref.invalidate(profileSettingsProvider);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _showDeleteAccountSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DeleteAccountConfirmationSheet(
        onConfirm: () => _performDeleteAccount(context, ref),
      ),
    );
  }

  Future<String?> _performDeleteAccount(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final result = await ref.read(deleteAccountUseCaseProvider)();
    if (result.isLeft) return result.leftValue.message;

    await ref
        .read(loginNotifierProvider.notifier)
        .logout(keepBiometricData: false);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = context.locale.languageCode;
    final appVersion = ref.watch(
      profileSettingsProvider.select((s) => s.appVersion),
    );
    return Drawer(
      backgroundColor:
          Theme.of(context).extension<AppColorTokens>()?.surface ??
          Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Profile header ────────────────────────────────────
                    ProfileHeader(
                      onEditProfile: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalProfilePage(),
                          ),
                        );
                      },
                    ),

                    // ── Divider ───────────────────────────────────────────
                    Divider(height: 1, color: context.appColors.divider),

                    // ── حسابي ─────────────────────────────────────────────
                    // const SettingsSectionTitle(title: 'حسابي'),
                    //
                    // NotificationsMenuItem(
                    //   onTap: () {
                    //     // Navigate to notifications
                    //   },
                    // ),
                    //
                    // SettingsMenuItem(
                    //   icon: Icons.account_balance_wallet_outlined,
                    //   iconColor: const Color(0xFF27AAE1),
                    //   iconBackground: const Color(0xFFE8F4FD),
                    //   label: 'طرق الدفع',
                    //   onTap: () {
                    //     // Navigate to payment methods
                    //   },
                    // ),
                    //
                    // SettingsMenuItem(
                    //   icon: Icons.favorite_outline_rounded,
                    //   iconColor: const Color(0xFFE91E8C),
                    //   iconBackground: const Color(0xFFFDE8F5),
                    //   label: 'الأماكن المحفوظة',
                    //   onTap: () {
                    //     // Navigate to saved places
                    //   },
                    // ),
                    //
                    // // ── Divider ───────────────────────────────────────────
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Divider(height: 1, color: AppColors.border),
                    // ),
                    //
                    // // ── الإعدادات العامة ─────────────────────────────────
                    SettingsSectionTitle(
                      title: 'profile.settings.generalSection'.tr(),
                    ),

                    LanguageToggleItem(
                      key: ValueKey('language-toggle-$localeCode'),
                    ),
                    DarkModeToggleItem(
                      key: ValueKey('dark-mode-toggle-$localeCode'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        height: 1,
                        color: context.appColors.divider,
                      ),
                    ),
                    SettingsSectionTitle(title: 'legal.sectionTitle'.tr()),
                    SettingsMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      iconColor: AppColors.primaryDark,
                      iconBackground: AppColors.primaryLight,
                      label: 'legal.privacyPolicy'.tr(),
                      onTap: () => _openPrivacyPolicy(context),
                    ),
                    SettingsMenuItem(
                      icon: Icons.gavel_outlined,
                      iconColor: AppColors.secondary,
                      iconBackground: const Color(0xFFE8F4FD),
                      label: 'legal.terms.title'.tr(),
                      onTap: () => _openTermsOfUse(context),
                    ),
                    //
                    // // ── Divider ───────────────────────────────────────────
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Divider(height: 1, color: AppColors.border),
                    // ),
                    //
                    // // ── الدعم والقانونية ──────────────────────────────────
                    // const SettingsSectionTitle(title: 'الدعم والقانونية'),
                    //
                    // const SizedBox(height: 8),
                    //
                    // // ── Divider ───────────────────────────────────────────
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Divider(height: 1, color: AppColors.border),
                    // ),
                    const SizedBox(height: 32),
                    // ── Logout ────────────────────────────────────────────
                    LogoutMenuItem(onTap: () => _showLogoutSheet(context, ref)),
                    DeleteAccountMenuItem(
                      horizontalPadding: 20,
                      onTap: () => _showDeleteAccountSheet(context, ref),
                    ),
                  ],
                ),
              ),
            ),

            // ── App version ───────────────────────────────────────────────
            AppVersionText(version: appVersion),
          ],
        ),
      ),
    );
  }
}
