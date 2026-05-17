import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../providers/notifications_provider.dart';
import 'notification_read_indicator.dart';
import 'notification_status_icon.dart';

class NotificationCard extends ConsumerWidget {
  final String notificationId;

  const NotificationCard({
    super.key,
    required this.notificationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(notificationByIdProvider(notificationId));
    final isMarking = ref.watch(notificationMarkingProvider(notificationId));

    if (notification == null) return const SizedBox.shrink();

    final colors = context.appColors;
    final isUnread = notification.isUnread;

    return InkWell(
      onTap: isUnread && !isMarking
          ? () => ref.read(notificationsProvider.notifier).markNotificationRead(notificationId)
          : null,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.08)
              : colors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: isUnread
                ? AppColors.primary.withValues(alpha: 0.25)
                : colors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationStatusIcon(status: notification.data.status),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          notification.data.title,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isMarking)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        NotificationReadIndicator(isUnread: isUnread),
                    ],
                  ),
                  if (notification.data.message.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.paddingXS),
                    AppText(
                      notification.data.message,
                      style: AppTextStyles.bodySecondary.copyWith(color: colors.textSecondary),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppDimensions.paddingS),
                  Wrap(
                    spacing: AppDimensions.paddingS,
                    runSpacing: AppDimensions.paddingXS,
                    children: [
                      AppText(notification.data.status.label,
                          style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                      if (notification.createdAtLabel.isNotEmpty)
                        AppText(notification.createdAtLabel,
                            style: AppTextStyles.caption.copyWith(color: colors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
