import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'RideInfoItem.dart';
import 'RideRouteCard.dart';
import 'RideServiceIconCard.dart';
import 'RideServiceTitleSection.dart';

class TripContainer extends StatelessWidget {
  const TripContainer({super.key, required this.serviceName});

  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          RideServiceIconCard(),
          SizedBox(height: 18),
          RideServiceTitleSection(serviceName: serviceName,),
          SizedBox(height: 36),
          RideRouteCard(),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RideInfoItem(
                title: 'التاريخ',
                value: 'الآن',
              ),
              RideInfoItem(
                title: 'الوصول',
                value: '٥ دقائق',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
