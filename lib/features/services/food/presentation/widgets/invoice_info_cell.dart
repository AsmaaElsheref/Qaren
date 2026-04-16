import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';

/// A single label + value cell used inside the invoice info grid.
class InvoiceInfoCell extends StatelessWidget {
  const InvoiceInfoCell({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.crossAlign = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final CrossAxisAlignment crossAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        AppText(
          label,
          secondary: true,
          style: const TextStyle(fontSize: AppDimensions.fontXS),
        ),
        const SizedBox(height: 4),
        AppText(
          value,
          style: TextStyle(
            fontSize: AppDimensions.fontM,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

