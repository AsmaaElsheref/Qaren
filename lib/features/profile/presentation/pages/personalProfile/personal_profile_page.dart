import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/loading.dart';
import '../../../../../core/localStorage/cache_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../../../../core/ui/widgets/AppTextStyles.dart';
import '../../../../auth/presentation/pages/login_page.dart';
import '../../../../auth/presentation/providers/user_profile_provider.dart';
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
    Navigator.of(context).pop();
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
    final userAsync = ref.watch(userProfileProvider);

    void openEditProfile(user) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EditProfilePage(user: user)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isHome == true ? null : PersonalProfileAppBar(
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
              'تعذّر تحميل البيانات، يرجى المحاولة مرة أخرى.',
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
              const ProfileSectionTitle(title: 'الحساب'),
              ProfileAccountCard(
                email: user.email,
                phone: user.phone,
              ),

              // ── عام ──────────────────────────────────────────────────
              const ProfileSectionTitle(title: 'عام'),
              ProfileGeneralMenuCard(
                onWallet: () {},
                onFavorites: () {},
                onNotifications: () {},
                onPrivacy: () {},
                onLogout: () => _showLogoutSheet(context),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
