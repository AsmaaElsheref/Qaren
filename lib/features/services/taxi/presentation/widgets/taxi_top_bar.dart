import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/icon_container.dart';

class TaxiTopBar extends StatelessWidget {
  const TaxiTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconContainer(
              onTap: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: AppDimensions.iconM,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            IconContainer(
              onTap: () {},
              icon: const Icon(
                Icons.menu_rounded,
                color: AppColors.textPrimary,
                size: AppDimensions.iconM,
              ),
            ),
            Spacer(),
            IconContainer(
              onTap: () {},
              icon: const Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.primary,
                size: AppDimensions.iconM,
              ),
            ),
          ],
        ),
      ),
    );
  }
}