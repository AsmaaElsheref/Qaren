import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/easy_localization.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../../auth/presentation/providers/auth_session_provider.dart';
import '../providers/profileSettings/profile_settings_provider.dart';
import 'edit_profile_button.dart';
import 'profile_avatar.dart';

class ProfileHeader extends ConsumerWidget {
  final VoidCallback onEditProfile;
  const ProfileHeader({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final isAuthenticated = ref.watch(authSessionProvider).isAuthenticated;
    final userProfile = isAuthenticated
        ? ref.watch(userProfileProvider).valueOrNull
        : null;
    final cachedUserName = ref.watch(profileUserNameProvider);
    final fetchedUserName = userProfile?.name.trim();
    final userName = fetchedUserName?.isNotEmpty == true
        ? fetchedUserName!
        : cachedUserName.isNotEmpty
        ? cachedUserName
        : 'profile.defaultUserName'.tr();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          ProfileAvatar(avatarUrl: userProfile?.image),
          const SizedBox(height: 12),
          AppText(
            userName,
            style: AppTextStyles.title.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          EditProfileButton(onTap: onEditProfile),
        ],
      ),
    );
  }
}
