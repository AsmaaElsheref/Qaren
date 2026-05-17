import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class ProfileStatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;

  const ProfileStatItem({
    super.key,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          value,
          style: AppTextStyles.title.copyWith(
            fontWeight: FontWeight.w800,
            color: highlight ? AppColors.primary : colors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        AppText(
          label,
          style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}
