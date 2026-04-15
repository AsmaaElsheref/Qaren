import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/food_category.dart';

class FoodCategoryChip extends StatelessWidget {
  const FoodCategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final FoodCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3,),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: isSelected ? const Color(0xFF2D3436) : AppColors.border,),
        ),
        child: AppText(category.name,style: TextStyle(fontSize: 14,color: isSelected ? AppColors.white : AppColors.textSecondary),),
      ),
    );
  }
}