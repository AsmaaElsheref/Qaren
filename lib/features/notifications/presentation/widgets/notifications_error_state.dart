import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class NotificationsErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const NotificationsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 44),
          const SizedBox(height: AppDimensions.paddingM),
          const AppText('حدث خطأ أثناء تحميل الإشعارات', style: AppTextStyles.title, textAlign: TextAlign.center),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingS),
            AppText(message!, style: AppTextStyles.bodySecondary, textAlign: TextAlign.center),
          ],
          const SizedBox(height: AppDimensions.paddingL),
          ElevatedButton.icon(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
            ),
            icon: const Icon(Icons.refresh_rounded),
            label: const AppText('إعادة المحاولة', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}

