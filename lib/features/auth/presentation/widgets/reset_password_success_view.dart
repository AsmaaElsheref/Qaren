import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';
import 'auth_submit_button.dart';

class ResetPasswordSuccessView extends StatelessWidget {
  final VoidCallback onBackToLogin;

  const ResetPasswordSuccessView({super.key, required this.onBackToLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.success,
            size: 44,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingL),
        AppText(
          AppStrings.resetPasswordSuccess,
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingXXL),
        AuthSubmitButton(
          label: AppStrings.forgotPasswordBackToLogin,
          isLoading: false,
          onPressed: onBackToLogin,
        ),
      ],
    );
  }
}
