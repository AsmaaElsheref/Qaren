import 'package:flutter/material.dart';
import 'package:qaren/core/constants/gap.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../food_strings.dart';

/// Route section in the invoice: [from] ---- [time icon] ---- [to]
class InvoiceRouteSection extends StatelessWidget {
  const InvoiceRouteSection({
    super.key,
    required this.from,
    required this.to,
    required this.deliveryMinutes,
  });

  final String from;
  final String to;
  final int deliveryMinutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        children: [
          // To
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppText(
                  FoodStrings.toLabel,
                  secondary: true,
                  style: TextStyle(fontSize: AppDimensions.fontXS),
                ),
                const SizedBox(height: 2),
                AppText(
                  to,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontM,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: List.generate(
                  8, (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 2,
                  color: const Color(0xFFD1D5DB),
                ),
                ),
              ),
              Gap.gapH5,
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.restaurant,
                  size: 18,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              AppText(
                '$deliveryMinutes ${FoodStrings.minutes}',
                secondary: true,
                style: const TextStyle(
                  fontSize: AppDimensions.fontXS,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // From
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppText(
                  FoodStrings.fromLabel,
                  secondary: true,
                  style: TextStyle(fontSize: AppDimensions.fontXS),
                ),
                const SizedBox(height: 2),
                AppText(
                  from,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontM,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

