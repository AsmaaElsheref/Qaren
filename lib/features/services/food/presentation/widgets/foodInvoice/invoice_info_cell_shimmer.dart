import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';

/// Shimmer cell that mimics a single [InvoiceInfoCell] label + value pair.
class InvoiceInfoCellShimmer extends StatelessWidget {
  const InvoiceInfoCellShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 90,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ],
    );
  }
}

