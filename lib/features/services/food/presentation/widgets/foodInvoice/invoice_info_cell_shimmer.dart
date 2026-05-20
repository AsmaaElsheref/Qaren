import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';

class InvoiceInfoCellShimmer extends StatelessWidget {
  const InvoiceInfoCellShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 10,
          decoration: BoxDecoration(
            color: colors.disabledBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 90,
          height: 14,
          decoration: BoxDecoration(
            color: colors.disabledBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ],
    );
  }
}

