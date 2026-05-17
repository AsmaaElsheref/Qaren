import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_strings.dart';
import 'package:qaren/core/constants/gap.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import 'profile_avatar_with_camera.dart';

class PersonalProfileCard extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final VoidCallback? onEdit;

  const PersonalProfileCard({
    super.key,
    required this.name,
    this.avatarUrl,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Mint strip with avatar overlapping ────────────────────────
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // Mint background strip
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
              ),
              Positioned(
                bottom: -45,
                child: ProfileAvatarWithCamera(
                  avatarUrl: avatarUrl,
                ),
              ),
              Positioned(
                top: 8,
                right: 10,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onEdit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppColors.borderFocused, size: 17),
                        Gap.gapW5,
                        AppText(
                          AppStrings.edit,
                          style: const TextStyle(
                            color: AppColors.borderFocused,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 52),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                name,
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Gap.gapW10,
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
