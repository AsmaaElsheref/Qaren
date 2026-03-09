import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class PinMap extends StatelessWidget {
  const PinMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.white,
              size: 22,
            ),
          ),
          // Pin stem
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Dot shadow
          Container(
            width: 10,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
