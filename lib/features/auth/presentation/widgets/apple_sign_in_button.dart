import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class AppleSignInButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppleSignInButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SignInWithAppleButton(
            text: label,
            height: AppDimensions.buttonHeight,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimensions.radiusL),
            ),
            onPressed: isLoading ? null : onPressed,
          ),
          if (isLoading)
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDimensions.radiusL),
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
