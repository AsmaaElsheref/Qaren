import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationsState extends Equatable {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final int currentPage;
  final int lastPage;
  final bool hasMore;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isMarkingAllRead;
  final Set<String> markingReadIds;
  final String? errorMessage;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasMore = false,
    this.isInitialLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isMarkingAllRead = false,
    this.markingReadIds = const {},
    this.errorMessage,
  });

  bool get isEmpty => !isInitialLoading && notifications.isEmpty && errorMessage == null;

  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    int? currentPage,
    int? lastPage,
    bool? hasMore,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isMarkingAllRead,
    Set<String>? markingReadIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasMore: hasMore ?? this.hasMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      markingReadIds: markingReadIds ?? this.markingReadIds,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        unreadCount,
        currentPage,
        lastPage,
        hasMore,
        isInitialLoading,
        isRefreshing,
        isLoadingMore,
        isMarkingAllRead,
        markingReadIds,
        errorMessage,
      ];
}

