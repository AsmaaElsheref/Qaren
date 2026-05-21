import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';

import '../providers/notifications_provider.dart';
import '../widgets/notifications_app_bar.dart';
import '../widgets/notifications_list.dart';
import '../widgets/notifications_loading_skeleton.dart';
import '../widgets/notifications_unread_count_card.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitialLoading = ref.watch(
      notificationsProvider.select((state) => state.isInitialLoading),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const NotificationsAppBar(),
        body: SafeArea(
          child: isInitialLoading
              ? const NotificationsLoadingSkeleton()
              : RefreshIndicator(
                  onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 220) {
                        ref.read(notificationsProvider.notifier).loadMore();
                      }
                      return false;
                    },
                    child: const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NotificationsUnreadCountCard(),
                          SizedBox(height: AppDimensions.paddingM),
                          NotificationsList(),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

