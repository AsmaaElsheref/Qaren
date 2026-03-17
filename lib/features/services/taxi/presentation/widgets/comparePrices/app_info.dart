import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../data/models/comparePrices/compare_prices_model.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key, required this.result});

  final PriceResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          result.appName,
          style: const TextStyle(
            fontSize: AppDimensions.fontM,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
            result.rating.toStringAsFixed(1),
            secondary: true,
            style: const TextStyle(fontSize: AppDimensions.fontXS),
          ),
            const SizedBox(width: 2),
            const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFC107)),
            const SizedBox(width: 6),
            AppText(
              result.rideType,
              secondary: true,
              style: const TextStyle(fontSize: AppDimensions.fontXS),
            ),
          ],
        ),
      ],
    );
  }
}