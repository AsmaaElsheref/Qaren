import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';

import '../../domain/entities/notification_status.dart';

class NotificationStatusIcon extends StatelessWidget {
  final NotificationStatus status;

  const NotificationStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      NotificationStatus.confirmed => AppColors.success,
      NotificationStatus.info => AppColors.secondary,
      NotificationStatus.pending => AppColors.primary,
      NotificationStatus.cancelled || NotificationStatus.failed => AppColors.error,
      NotificationStatus.unknown => AppColors.textSecondary,
    };

    final icon = switch (status) {
      NotificationStatus.confirmed => Icons.check_circle_outline_rounded,
      NotificationStatus.info => Icons.info_outline_rounded,
      NotificationStatus.pending => Icons.schedule_rounded,
      NotificationStatus.cancelled || NotificationStatus.failed => Icons.warning_amber_rounded,
      NotificationStatus.unknown => Icons.notifications_none_rounded,
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Icon(icon, color: color),
    );
  }
}

