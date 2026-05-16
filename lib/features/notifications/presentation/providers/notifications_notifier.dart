import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/utils/print/custom_print.dart';

import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notifications_state.dart';

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;

  NotificationsNotifier({
    required this.getNotificationsUseCase,
    required this.getUnreadCountUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
  }) : super(const NotificationsState());

  Future<void> loadInitial() async {
    state = state.copyWith(isInitialLoading: true, clearError: true);
    await Future.wait([fetchNotifications(page: 1, append: false), fetchUnreadCount()]);
    if (!mounted) return;
    state = state.copyWith(isInitialLoading: false);
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, clearError: true);
    await Future.wait([fetchNotifications(page: 1, append: false), fetchUnreadCount()]);
    if (!mounted) return;
    state = state.copyWith(isRefreshing: false);
  }

  Future<void> fetchNotifications({required int page, required bool append}) async {
    final result = await getNotificationsUseCase(page: page);
    if (!mounted) return;
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (pageData) {
        final nextNotifications = append
            ? [...state.notifications, ...pageData.notifications]
            : pageData.notifications;
        state = state.copyWith(
          notifications: nextNotifications,
          currentPage: pageData.currentPage,
          lastPage: pageData.lastPage,
          hasMore: pageData.hasMore,
          clearError: true,
        );
      },
    );
  }

  Future<void> fetchUnreadCount() async {
    final result = await getUnreadCountUseCase();
    if (!mounted) return;
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (count) => state = state.copyWith(unreadCount: count, clearError: true),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isInitialLoading) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await fetchNotifications(page: state.currentPage + 1, append: true);
    if (!mounted) return;
    state = state.copyWith(isLoadingMore: false);
  }

  Future<void> markNotificationRead(String notificationId) async {
    final target = state.notifications.where((item) => item.id == notificationId).firstOrNull;
    if (target == null || !target.isUnread || state.markingReadIds.contains(notificationId)) return;

    state = state.copyWith(markingReadIds: {...state.markingReadIds, notificationId});
    final result = await markNotificationReadUseCase(notificationId: notificationId);
    if (!mounted) return;

    result.fold(
      (failure) {
        final nextIds = {...state.markingReadIds}..remove(notificationId);
        state = state.copyWith(markingReadIds: nextIds, errorMessage: failure.message);
      },
      (_) {
        final readAt = DateTime.now().toIso8601String();
        final updated = state.notifications
            .map((item) => item.id == notificationId ? item.copyAsRead(readAt) : item)
            .toList(growable: false);
        final nextIds = {...state.markingReadIds}..remove(notificationId);
        state = state.copyWith(
          notifications: updated,
          unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
          markingReadIds: nextIds,
          clearError: true,
        );
      },
    );
  }

  Future<bool> markAllRead() async {
    if (state.unreadCount <= 0 || state.isMarkingAllRead) return false;

    state = state.copyWith(isMarkingAllRead: true, clearError: true);
    final result = await markAllNotificationsReadUseCase();
    if (!mounted) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(isMarkingAllRead: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        final readAt = DateTime.now().toIso8601String();
        final updated = state.notifications
            .map((item) => item.isUnread ? item.copyAsRead(readAt) : item)
            .toList(growable: false);
        state = state.copyWith(
          notifications: updated,
          unreadCount: 0,
          isMarkingAllRead: false,
          markingReadIds: const {},
          clearError: true,
        );
        return true;
      },
    );
  }
}

