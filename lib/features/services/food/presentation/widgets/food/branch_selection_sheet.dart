import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../domain/entities/food_warehouse.dart';
import 'branch_option_card.dart';

/// Bottom sheet that lets the user pick a branch/warehouse for a food product
/// when the product is offered by more than one active branch.
///
/// Returns the selected [FoodWarehouse] via [Navigator.pop], or null if the
/// user dismisses the sheet.
class BranchSelectionSheet extends StatelessWidget {
  const BranchSelectionSheet({super.key, required this.warehouses});

  final List<FoodWarehouse> warehouses;

  /// Convenience opener — keeps page-level code free of bottom-sheet plumbing.
  static Future<FoodWarehouse?> show(
    BuildContext context, {
    required List<FoodWarehouse> warehouses,
  }) {
    return showModalBottomSheet<FoodWarehouse>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BranchSelectionSheet(warehouses: warehouses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const AppText(
              'اختر الفرع',
              style: TextStyle(
                fontSize: AppDimensions.fontL,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const AppText(
              'اختر الفرع المناسب لهذا المنتج',
              secondary: true,
              style: TextStyle(fontSize: AppDimensions.fontXS),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: warehouses.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppDimensions.paddingS),
                itemBuilder: (_, i) => BranchOptionCard(
                  warehouse: warehouses[i],
                  onTap: () => Navigator.of(context).pop(warehouses[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

