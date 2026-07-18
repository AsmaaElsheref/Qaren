import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class BookingEmptyState extends StatelessWidget {
  const BookingEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.textSecondary,
                size: 42,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            AppText(
              'bookings.history.emptyTitle'.tr(),
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppDimensions.paddingS),
            AppText(
              'bookings.history.emptySubtitle'.tr(),
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
