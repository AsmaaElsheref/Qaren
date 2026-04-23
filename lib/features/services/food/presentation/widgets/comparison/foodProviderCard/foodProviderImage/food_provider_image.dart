import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../domain/entities/food_provider_model.dart';

class FoodProviderImage extends StatelessWidget {
  const FoodProviderImage({super.key, required this.provider});

  final FoodProviderModel provider;

  bool get _hasValidNetworkImage {
    final url = provider.logoUrl?.trim();
    if (url == null || url.isEmpty) return false;

    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        width: 48,
        height: 48,
        color: AppColors.surfaceVariant,
        child: _hasValidNetworkImage
            ? CachedNetworkImage(
          imageUrl: provider.logoUrl!.trim(),
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => const Icon(
            Icons.restaurant_rounded,
            color: AppColors.textHint,
            size: 24,
          ),
          placeholder: (_, __) => const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ) : const Icon(
          Icons.restaurant_rounded,
          color: AppColors.textHint,
          size: 24,
        ),
      ),
    );
  }
}