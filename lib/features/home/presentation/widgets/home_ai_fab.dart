import 'package:flutter/material.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/theme/app_colors.dart';

class HomeAiFab extends StatelessWidget {
  const HomeAiFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(AppImages.qarenLogo),
    );
  }
}

