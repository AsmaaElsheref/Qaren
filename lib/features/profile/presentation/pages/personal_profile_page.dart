import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../providers/personal_profile_provider.dart';
import '../widgets/logout_confirmation_sheet.dart';
import '../widgets/personal_profile_app_bar.dart';
import '../widgets/personal_profile_card.dart';
import '../widgets/profile_account_card.dart';
import '../widgets/profile_general_menu_card.dart';
import '../widgets/profile_section_title.dart';

class PersonalProfilePage extends ConsumerWidget {
  const PersonalProfilePage({super.key});

  Future<void> _showLogoutSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LogoutConfirmationSheet(
        onConfirm: () => _performLogout(context),
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    Navigator.of(context).pop(); // close sheet
    await CacheHelper.clearAll();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PersonalProfileAppBar(
        onBack: () => Navigator.of(context).pop(),
        onEdit: () {
          // TODO: navigate to edit profile screen
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Profile card (avatar + name + stats) ──────────────────
            PersonalProfileCard(
              onCameraTap: () {
                // TODO: open image picker
              },
            ),

            // ── الحساب ────────────────────────────────────────────────
            const ProfileSectionTitle(title: 'الحساب'),
            const ProfileAccountCard(),

            // ── عام ───────────────────────────────────────────────────
            const ProfileSectionTitle(title: 'عام'),
            ProfileGeneralMenuCard(
              onWallet: () {
                // TODO: navigate to wallet
              },
              onFavorites: () {
                // TODO: navigate to favorites
              },
              onNotifications: () {
                // TODO: navigate to notifications
              },
              onPrivacy: () {
                // TODO: navigate to privacy
              },
              onLogout: () => _showLogoutSheet(context),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

