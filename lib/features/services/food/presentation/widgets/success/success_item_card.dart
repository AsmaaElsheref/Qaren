import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/network/apiRoutes/api_routes.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../data/models/food_booking_item_response.dart';
import '../../food_strings.dart';

class SuccessItemCard extends StatelessWidget {
  const SuccessItemCard({super.key, required this.item});

  final FoodBookingItemResponse item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiRoutes.foodImageUrl(item.productThumbnailSnapshot);
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              placeholder: (_, __) => _placeholder(colors),
              errorWidget: (_, __, ___) => _placeholder(colors),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.displayName,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: AppDimensions.fontS,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppText(
                  '${FoodStrings.quantityShort}: ${item.quantity}',
                  secondary: true,
                  style: const TextStyle(fontSize: AppDimensions.fontXS),
                ),
              ],
            ),
          ),
          AppText(
            '${item.subtotal.toInt()} ${FoodStrings.currencyShort}',
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

  Widget _placeholder(colors) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colors.disabledBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: const Icon(
          Icons.restaurant_rounded,
          color: AppColors.textHint,
        ),
      );
}

