import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';

/// A single row in the order summary: label on the right, value on the left.
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
  }) : assert(value != null || valueWidget != null);

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          style: const TextStyle(
            fontSize: AppDimensions.fontS,
            color: AppColors.textSecondary,
          ),
        ),
        valueWidget ??
            AppText(
              value!,
              style: const TextStyle(
                fontSize: AppDimensions.fontS,
                color: AppColors.textSecondary,
              ),
            ),
      ],
    );
  }
}
