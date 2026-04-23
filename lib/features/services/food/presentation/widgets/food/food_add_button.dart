import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class FoodAddButton extends StatelessWidget {
  const FoodAddButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 27,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }
}

