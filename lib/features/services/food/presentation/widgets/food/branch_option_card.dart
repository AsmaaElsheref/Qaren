import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../domain/entities/food_warehouse.dart';

/// Single selectable branch row inside [BranchSelectionSheet].
class BranchOptionCard extends StatelessWidget {
  const BranchOptionCard({
    super.key,
    required this.warehouse,
    required this.onTap,
  });

  final FoodWarehouse warehouse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.storefront_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    warehouse.name,
                    style: TextStyle(
                      // fontSize: AppDimensions.fontM,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (warehouse.address.isNotEmpty ||
                      warehouse.area.isNotEmpty ||
                      warehouse.city.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    AppText(
                      [
                        if (warehouse.address.isNotEmpty) warehouse.address,
                        if (warehouse.area.isNotEmpty) warehouse.area,
                        if (warehouse.city.isNotEmpty) warehouse.city,
                      ].join(' · '),
                      secondary: true,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontXS,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

