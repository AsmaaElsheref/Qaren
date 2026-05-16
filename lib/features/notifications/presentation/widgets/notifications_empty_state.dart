import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
              child: const Icon(Icons.notifications_off_outlined, color: AppColors.textSecondary, size: 38),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            const AppText('لا توجد إشعارات', style: AppTextStyles.title, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.paddingS),
            const AppText(
              'ستظهر إشعاراتك هنا عند توفر تحديثات جديدة.',
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

