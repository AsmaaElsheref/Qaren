import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

class BiometricsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BiometricsButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.fingerprint,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          AppStrings.faceLogin,
          style: TextStyle(
            fontSize: AppDimensions.fontXS,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

