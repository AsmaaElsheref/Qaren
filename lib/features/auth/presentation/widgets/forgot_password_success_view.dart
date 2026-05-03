import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class ForgotPasswordSuccessView extends StatelessWidget {
  final String email;
  final VoidCallback onBackToLogin;

  const ForgotPasswordSuccessView({
    super.key,
    required this.email,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: AppColors.primary,
            size: 48,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingL),
        AppText(
          AppStrings.forgotPasswordSuccessTitle,
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingS),
        AppText(
          AppStrings.forgotPasswordSuccessSubtitle,
          secondary: true,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppDimensions.fontM,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: AppText(
            email,
            style: const TextStyle(
              fontSize: AppDimensions.fontM,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXXL),
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          child: TextButton(
            onPressed: onBackToLogin,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                side: const BorderSide(color: AppColors.border, width: 1.5),
              ),
            ),
            child: AppText(
              AppStrings.forgotPasswordBackToLogin,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

