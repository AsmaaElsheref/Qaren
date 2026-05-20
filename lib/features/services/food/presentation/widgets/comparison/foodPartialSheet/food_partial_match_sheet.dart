import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../../core/ui/widgets/AppText.dart';
import '../../../../domain/entities/food_provider_model.dart';
import '../../../food_strings.dart';

class FoodPartialMatchSheet extends StatelessWidget {
  const FoodPartialMatchSheet({
    super.key,
    required this.provider,
    required this.availableNames,
    required this.missingNames,
  });

  final FoodProviderModel provider;
  final List<String> availableNames;
  final List<String> missingNames;

  static Future<bool?> show(
    BuildContext context, {
    required FoodProviderModel provider,
    required List<String> availableNames,
    required List<String> missingNames,
  }) {
    final colors = context.appColors;
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      builder: (_) => FoodPartialMatchSheet(
        provider: provider,
        availableNames: availableNames,
        missingNames: missingNames,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppDimensions.paddingL,
          right: AppDimensions.paddingL,
          top: AppDimensions.paddingL,
          bottom: AppDimensions.paddingL +
              MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFFF9500),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: AppText(
                    FoodStrings.partialMatchTitle,
                    style: TextStyle(
                      fontSize: AppDimensions.fontL,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),
            const AppText(
              FoodStrings.partialMatchDescription,
              secondary: true,
              style: TextStyle(
                fontSize: AppDimensions.fontS,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            if (availableNames.isNotEmpty) ...[
              const AppText(
                FoodStrings.availableItems,
                style: TextStyle(
                  fontSize: AppDimensions.fontS,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final name in availableNames)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: AppText(
                              name,
                              style: TextStyle(
                                fontSize: AppDimensions.fontS,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),
            ],
            if (missingNames.isNotEmpty) ...[
              const AppText(
                FoodStrings.missingItems,
                style: TextStyle(
                  fontSize: AppDimensions.fontS,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFF3B30),
                ),
              ),
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final name in missingNames)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.cancel_rounded,
                            size: 14,
                            color: Color(0xFFFF3B30),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: AppText(
                              name,
                              style: TextStyle(
                                fontSize: AppDimensions.fontS,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),
            ],
            const SizedBox(height: AppDimensions.paddingL),
            AppButton(
              label: FoodStrings.continueOrder,
              onTap: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const AppText(
                  FoodStrings.cancel,
                  style: TextStyle(
                    fontSize: AppDimensions.fontM,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


