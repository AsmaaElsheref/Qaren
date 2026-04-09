import 'package:flutter/material.dart';
import 'package:qaren/core/constants/gap.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';

class EstimatedTime extends StatelessWidget {
  const EstimatedTime({super.key, required this.distance});

  final String distance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'المسافة',
          secondary: true,
          style: TextStyle(fontSize: AppDimensions.fontXS),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                distance,
                secondary: true,
                style: TextStyle(fontSize: AppDimensions.fontXS,color: AppColors.black),
              ),
              Gap.gapW5,
              const Icon(
                Icons.local_taxi,
                size: 13,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}