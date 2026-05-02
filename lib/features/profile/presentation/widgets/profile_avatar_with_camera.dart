import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileAvatarWithCamera extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback onCameraTap;

  const ProfileAvatarWithCamera({
    super.key,
    this.avatarUrl,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const ProfileAvatarFallbackIcon(),
                  )
                : const ProfileAvatarFallbackIcon(),
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   right: 0,
        //   child: GestureDetector(
        //     onTap: onCameraTap,
        //     child: Container(
        //       width: 28,
        //       height: 28,
        //       decoration: BoxDecoration(
        //         color: AppColors.textPrimary,
        //         shape: BoxShape.circle,
        //         border: Border.all(color: AppColors.white, width: 2),
        //       ),
        //       child: const Icon(
        //         Icons.camera_alt_rounded,
        //         size: 14,
        //         color: AppColors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class ProfileAvatarFallbackIcon extends StatelessWidget {
  const ProfileAvatarFallbackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.person_rounded,
        size: 44,
        color: AppColors.textHint,
      ),
    );
  }
}

