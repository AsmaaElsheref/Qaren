import '../../domain/entities/notifications_page_entity.dart';
import 'notification_model.dart';

class NotificationsPaginationModel extends NotificationsPageEntity {
  const NotificationsPaginationModel({
    required super.notifications,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.nextPageUrl,
  });

  factory NotificationsPaginationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? const [];
    return NotificationsPaginationModel(
      notifications: data
          .whereType<Map>()
          .map((item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false),
      currentPage: NotificationModel.parseInt(json['current_page'], fallback: 1),
      lastPage: NotificationModel.parseInt(json['last_page'], fallback: 1),
      perPage: NotificationModel.parseInt(json['per_page'], fallback: 15),
      total: NotificationModel.parseInt(json['total']),
      nextPageUrl: json['next_page_url'] as String?,
    );
  }
}

