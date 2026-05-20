import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../domain/entities/cart_item.dart';
import '../../food_strings.dart';

class CheckoutItemCard extends StatelessWidget {
  const CheckoutItemCard({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Container(
              width: 56,
              height: 56,
              color: colors.disabledBackground,
              child: item.imageUrl.isEmpty
                  ? const Icon(
                      Icons.restaurant_rounded,
                      color: AppColors.textHint,
                    )
                  : Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.textHint,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: AppDimensions.fontS,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                AppText(
                  '${FoodStrings.quantityShort}: ${item.quantity}',
                  secondary: true,
                  style: const TextStyle(fontSize: AppDimensions.fontXS),
                ),
                if (item.modifiers.isNotEmpty)
                  AppText(
                    item.modifiers.map((m) => '${m.name}: ${m.value}').join(' · '),
                    secondary: true,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontXS,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (item.specialInstructions.isNotEmpty)
                  AppText(
                    item.specialInstructions,
                    secondary: true,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontXS,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          AppText(
            '${item.lineTotal.toInt()} ${FoodStrings.currencyShort}',
            style: TextStyle(
              fontSize: AppDimensions.fontS,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

