import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppTextField.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';

class SearchMap extends StatelessWidget {
  const SearchMap({super.key, required this.searchController, required this.searchAddress});

  final TextEditingController searchController ;
  final Function(String) searchAddress ;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          child: Row(
            children: [
              // Search bar
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: AppTextField(
                    controller: searchController,
                    hint: 'ابحث عن موقع على الخريطة...',
                    onSubmitted: searchAddress
                  )
                ),
              ),
              const SizedBox(width: AppDimensions.paddingS),
              // Back button
              GestureDetector(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
