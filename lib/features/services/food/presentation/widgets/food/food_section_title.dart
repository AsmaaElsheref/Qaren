import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';

class FoodSectionTitle extends StatelessWidget {
  const FoodSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: AppText(title,style: TextStyle(fontSize: AppDimensions.fontM, fontWeight: FontWeight.w700,color: AppColors.textSecondary),)
      ),
    );
  }
}

