import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../core/ui/widgets/icon_container.dart';
import '../../food_strings.dart';

/// Top header for the price comparison screen.
/// Contains: [filter icon] ... [title + breadcrumb] ... [back arrow]
class ComparisonHeader extends StatelessWidget {
  const ComparisonHeader({
    super.key,
    required this.from,
    required this.to,
  });

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        children: [
          IconContainer(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppText(
                FoodStrings.comparisonTitle,
                style: TextStyle(
                  fontSize: AppDimensions.fontL,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    from,
                    secondary: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: AppDimensions.fontXS),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppText(
                    to,
                    secondary: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: AppDimensions.fontXS),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconContainer(
            icon: const Icon(
              Icons.filter_alt_outlined,
              size: 20,
              color: AppColors.textPrimary,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

