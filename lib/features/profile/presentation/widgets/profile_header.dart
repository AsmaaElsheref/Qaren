import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final userImage = ref.watch(userProfileProvider).value?.image;
    final state = ref.watch(
      profileSettingsProvider.select(
        (s) => (
          userName: s.userName,
          accountSubtitle: s.accountSubtitle,
          avatarUrl: s.avatarUrl,
        ),
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
            state.userName,
            style: AppTextStyles.title.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          AppText(
            state.accountSubtitle,
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
