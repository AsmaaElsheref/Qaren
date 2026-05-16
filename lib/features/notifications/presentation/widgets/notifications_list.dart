import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';

import '../providers/notifications_provider.dart';
import 'notification_card.dart';
import 'notifications_empty_state.dart';
import 'notifications_error_state.dart';

class NotificationsList extends ConsumerWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(notificationIdsProvider);
    final errorMessage = ref.watch(notificationsProvider.select((state) => state.errorMessage));
    final isLoadingMore = ref.watch(notificationsProvider.select((state) => state.isLoadingMore));

    if (ids.isEmpty && errorMessage != null) {
      return NotificationsErrorState(
        message: errorMessage,
        onRetry: () => ref.read(notificationsProvider.notifier).loadInitial(),
      );
    }

    if (ids.isEmpty) return const NotificationsEmptyState();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == ids.length) {
          return const Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return NotificationCard(
          key: ValueKey(ids[index]),
          notificationId: ids[index],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.paddingM),
      itemCount: ids.length + (isLoadingMore ? 1 : 0),
    );
  }
}

