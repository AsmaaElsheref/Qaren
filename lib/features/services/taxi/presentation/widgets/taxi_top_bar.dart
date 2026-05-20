import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/icon_container.dart';

class TaxiTopBar extends StatelessWidget {
  const TaxiTopBar({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
              onTap: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: colors.textPrimary,
                size: AppDimensions.iconM,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            IconContainer(
              onTap: onMenuTap ?? () {},
              icon: Icon(
                Icons.menu_rounded,
                color: colors.textPrimary,
                size: AppDimensions.iconM,
              ),
            ),
            const Spacer(),
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