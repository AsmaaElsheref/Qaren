import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/features/profile/presentation/pages/personal_profile_page.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../providers/profile_settings_provider.dart';
import '../widgets/app_version_text.dart';
import '../widgets/dark_mode_toggle_item.dart';
import '../widgets/language_toggle_item.dart';
import '../widgets/logout_confirmation_sheet.dart';
import '../widgets/logout_menu_item.dart';
import '../widgets/notifications_menu_item.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_menu_item.dart';
import '../widgets/settings_section_title.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  Future<void> _showLogoutSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => LogoutConfirmationSheet(
        onConfirm: () => _performLogout(context),
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    // Close sheet first
    Navigator.of(context).pop();
    // Close drawer
    if (context.mounted) Navigator.of(context).pop();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    }

    await CacheHelper.clearAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(
      profileSettingsProvider.select((s) => s.appVersion),
    );

    return Drawer(
      backgroundColor: AppColors.white,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalProfilePage(),));
                      },
                    ),

                    // ── Divider ───────────────────────────────────────────
                    const Divider(height: 1, color: AppColors.border),

                    // ── حسابي ─────────────────────────────────────────────
                    const SettingsSectionTitle(title: 'حسابي'),

                    NotificationsMenuItem(
                      onTap: () {
                        // Navigate to notifications
                      },
                    ),

                    SettingsMenuItem(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: const Color(0xFF27AAE1),
                      iconBackground: const Color(0xFFE8F4FD),
                      label: 'طرق الدفع',
                      onTap: () {
                        // Navigate to payment methods
                      },
                    ),

                    SettingsMenuItem(
                      icon: Icons.favorite_outline_rounded,
                      iconColor: const Color(0xFFE91E8C),
                      iconBackground: const Color(0xFFFDE8F5),
                      label: 'الأماكن المحفوظة',
                      onTap: () {
                        // Navigate to saved places
                      },
                    ),

                    // ── Divider ───────────────────────────────────────────
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.border),
                    ),

                    // ── الإعدادات العامة ──────────────────────────────────
                    const SettingsSectionTitle(title: 'الإعدادات العامة'),

                    const LanguageToggleItem(),
                    const DarkModeToggleItem(),

                    // ── Divider ───────────────────────────────────────────
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.border),
                    ),

                    // ── الدعم والقانونية ──────────────────────────────────
                    const SettingsSectionTitle(title: 'الدعم والقانونية'),

                    const SizedBox(height: 8),

                    // ── Divider ───────────────────────────────────────────
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.border),
                    ),

                    // ── Logout ────────────────────────────────────────────
                    LogoutMenuItem(
                      onTap: () => _showLogoutSheet(context, ref),
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

