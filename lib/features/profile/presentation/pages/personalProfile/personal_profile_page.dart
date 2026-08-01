import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/loading.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../../../../core/ui/widgets/AppTextStyles.dart';
import '../../../../auth/presentation/pages/login_page.dart';
import '../../../../auth/presentation/providers/user_profile_provider.dart';
import '../../../../auth/presentation/providers/login_providers.dart';
import '../editProfile/edit_profile_page.dart';
import '../../widgets/logout_confirmation_sheet.dart';
import '../../widgets/personal_profile_app_bar.dart';
import '../../widgets/personal_profile_card.dart';
import '../../widgets/profile_account_card.dart';
import '../../widgets/profile_general_menu_card.dart';
import '../../widgets/profile_section_title.dart';

class PersonalProfilePage extends ConsumerWidget {
  const PersonalProfilePage({super.key, this.isHome});

  final bool? isHome;

  Future<void> _showLogoutSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LogoutConfirmationSheet(
        onConfirm: () => _performLogout(context, ref),
      ),
    );
  }

  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    await ref.read(loginNotifierProvider.notifier).logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    void openEditProfile(user) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => EditProfilePage(user: user)));
    }

    return Scaffold(
      appBar: isHome == true
          ? null
          : PersonalProfileAppBar(
              onBack: () => Navigator.of(context).pop(),
              onEdit: () {
                final user = userAsync.valueOrNull;
                if (user != null) openEditProfile(user);
              },
            ),
      body: userAsync.when(
        loading: () => Loading(),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppText(
              'profile.loadError'.tr(),
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (user) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Profile card ─────────────────────────────────────────
              PersonalProfileCard(
                name: user.name,
                avatarUrl: user.image,
                onEdit: () => openEditProfile(user),
              ),

              // ── الحساب ───────────────────────────────────────────────
              ProfileSectionTitle(title: 'profile.section.account'.tr()),
              ProfileAccountCard(email: user.email, phone: user.phone),

              // ── عام ──────────────────────────────────────────────────
              ProfileSectionTitle(title: 'profile.section.general'.tr()),
              ProfileGeneralMenuCard(
                onWallet: () {},
                onFavorites: () {},
                onNotifications: () {},
                onPrivacy: () {},
                onLogout: () => _showLogoutSheet(context, ref),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
