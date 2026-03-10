import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({super.key, required this.searchAddress});

  final Function(String) searchAddress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => searchAddress,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: AppColors.white,
          size: AppDimensions.iconM,
        ),
      ),
    );
  }
}
