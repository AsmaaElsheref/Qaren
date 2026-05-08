import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileAvatarWithCamera extends StatelessWidget {
  final String? avatarUrl;

  const ProfileAvatarWithCamera({
    super.key,
    this.avatarUrl,
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
          child: RepaintBoundary(
            child: ClipOval(
              child: CachedNetworkImage(
              imageUrl: avatarUrl??'',
              placeholder: (context, url) => const ProfileAvatarFallbackIcon(),
              errorWidget: (context, url, error) => const ProfileAvatarFallbackIcon(),
              fit: BoxFit.cover,
            ),
            ),
          ),
        ),
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

