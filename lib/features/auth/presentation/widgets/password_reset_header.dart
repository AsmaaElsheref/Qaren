import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class PasswordResetHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const PasswordResetHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingL),
        AppText(
          title,
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingS),
        AppText(
          subtitle,
          secondary: true,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppDimensions.fontM,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

