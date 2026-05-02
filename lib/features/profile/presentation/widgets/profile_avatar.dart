import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;

  const ProfileAvatar({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary, width: 2.5),
          ),
          child: ClipOval(
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const ProfileAvatarPlaceholder(),
                  )
                : const ProfileAvatarPlaceholder(),
          ),
        ),
        Positioned(
          bottom: -2,
          left: -2,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF4A730),
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 12,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileAvatarPlaceholder extends StatelessWidget {
  const ProfileAvatarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.person_rounded,
        size: 36,
        color: AppColors.textHint,
      ),
    );
  }
}

