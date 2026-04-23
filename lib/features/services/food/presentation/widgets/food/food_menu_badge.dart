import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/icon_container.dart';
import '../../../../../../core/theme/app_colors.dart';

class FoodMenuBadge extends StatelessWidget {
  const FoodMenuBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconContainer(
          icon: const Icon(
            Icons.menu_rounded,
            size: 26,
            color: AppColors.textPrimary,
          ),
          onTap: (){}
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: const Text(
              '7',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

