import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import '../../../../core/theme/app_colors.dart';

class GradientLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const GradientLoginButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(label: label, onTap: onPressed, isLoading: isLoading,color: AppColors.primary,radius: 16,);
  }
}

