import 'package:flutter/material.dart';
import 'package:qaren/core/constants/gap.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';

class EstimatedTime extends StatelessWidget {
  const EstimatedTime({super.key, required this.distance});

  final String distance;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'taxi.compare.distance'.tr(),
          secondary: true,
          style: const TextStyle(fontSize: AppDimensions.fontXS),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                'taxi.compare.kilometer'.tr(),
                secondary: true,
                style: TextStyle(
                  fontSize: AppDimensions.fontXS,
                  color: colors.textPrimary,
                ),
              ),
              Gap.gapW5,
              AppText(
                '$distance',
                secondary: true,
                style: TextStyle(
                  fontSize: AppDimensions.fontXS,
                  color: colors.textPrimary,
                ),
              ),
              Gap.gapW5,
              const Icon(Icons.local_taxi, size: 13, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
