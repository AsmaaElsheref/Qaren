import '../models/mark_notification_read_response_model.dart';
import '../models/notifications_response_model.dart';
import '../models/unread_count_response_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications({required int page});

  Future<UnreadCountResponseModel> getUnreadCount();

  Future<MarkNotificationReadResponseModel> markNotificationRead({required String notificationId});

  Future<MarkNotificationReadResponseModel> markAllNotificationsRead();
}

