import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';
import '../providers/profile_settings_provider.dart';
import 'edit_profile_button.dart';
import 'profile_avatar.dart';

class ProfileHeader extends ConsumerWidget {
  final VoidCallback onEditProfile;

  const ProfileHeader({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when userName changes, not on dark/language toggle
    final userName = ref.watch(profileUserNameProvider);
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
          ProfileAvatar(avatarUrl: state.avatarUrl),
          const SizedBox(height: 12),
          AppText(
            userName,
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          AppText(
            state.membershipLabel,
            style: AppTextStyles.bodySecondary
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          EditProfileButton(onTap: onEditProfile),
        ],
      ),
    );
  }
}

