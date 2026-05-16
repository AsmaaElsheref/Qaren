import 'package:equatable/equatable.dart';

import 'notification_entity.dart';

class NotificationsPageEntity extends Equatable {
  final List<NotificationEntity> notifications;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;

  const NotificationsPageEntity({
    required this.notifications,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.nextPageUrl,
  });

  bool get hasMore => currentPage < lastPage || (nextPageUrl != null && nextPageUrl!.isNotEmpty);

  @override
  List<Object?> get props => [notifications, currentPage, lastPage, perPage, total, nextPageUrl];
}

