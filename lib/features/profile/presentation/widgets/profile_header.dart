import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_constants.dart';
import 'package:qaren/core/localStorage/cache_helper.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';
import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../providers/profileSettings/profile_settings_provider.dart';
import 'edit_profile_button.dart';
import 'profile_avatar.dart';

class ProfileHeader extends ConsumerWidget {
  final VoidCallback onEditProfile;
  const ProfileHeader({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final userName = CacheHelper.getData(key: AppConstants.userName);
    final userImage = ref.watch(userProfileProvider).value?.image;
    final state = ref.watch(
      profileSettingsProvider.select(
        (s) => (membershipLabel: s.membershipLabel, avatarUrl: s.avatarUrl),
      ),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          ProfileAvatar(avatarUrl: userImage),
          const SizedBox(height: 12),
          AppText(
            userName,
            style: AppTextStyles.title.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          AppText(
            state.membershipLabel,
            style: AppTextStyles.bodySecondary.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          EditProfileButton(onTap: onEditProfile),
        ],
      ),
    );
  }
}