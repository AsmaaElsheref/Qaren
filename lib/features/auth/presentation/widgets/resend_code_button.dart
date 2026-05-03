import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class ResendCodeButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const ResendCodeButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : AppText(
              AppStrings.verifyCodeResend,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
    );
  }
}

