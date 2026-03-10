import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/ui/widgets/AppTextField.dart';

class SearchMapBar extends StatelessWidget {
  const SearchMapBar({super.key, required this.searchController, required this.searchAddress});

  final TextEditingController searchController;
  final Function(String) searchAddress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
