import 'package:flutter/material.dart';
import 'package:qaren/core/constants/gap.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

/// Name + description labels for a service category card.
/// Colors are resolved from [AppColorTokens] so they adapt to light/dark mode.
/// When [isEnabled] is false, both labels use the theme disabled text token.
class CategoryLabels extends StatelessWidget {
  const CategoryLabels({
    super.key,
    required this.name,
    required this.description,
    this.isEnabled = true,
  });

  final String name;
  final String description;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final titleColor =
        isEnabled ? colors.textPrimary : colors.disabledText;
    final descColor =
        isEnabled ? colors.textSecondary : colors.disabledText.withValues(alpha: 0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          name,
          textAlign: TextAlign.right,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: titleColor,
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
            color: descColor,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
