import 'package:flutter/material.dart';
import 'package:qaren/core/constants/gap.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

/// Name + description labels for a service category card.
/// Colors are resolved from [AppColorTokens] so they adapt to light/dark mode.
class CategoryLabels extends StatelessWidget {
  const CategoryLabels({
    super.key,
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          name,
          textAlign: TextAlign.right,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.textPrimary,
            fontSize: 13,
            height: 1.3,
          ),
        ),
        Gap.gapH5,
        AppText(
          description,
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: colors.textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

