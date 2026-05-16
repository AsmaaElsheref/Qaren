import 'notifications_pagination_model.dart';

class NotificationsResponseModel {
  final bool success;
  final NotificationsPaginationModel page;

  const NotificationsResponseModel({
    required this.success,
    required this.page,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return NotificationsResponseModel(
      success: json['success'] as bool? ?? false,
      page: NotificationsPaginationModel.fromJson(
        data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
      ),
    );
  }
}

