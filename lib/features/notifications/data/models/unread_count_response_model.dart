import 'notification_model.dart';

class UnreadCountResponseModel {
  final bool success;
  final int count;

  const UnreadCountResponseModel({
    required this.success,
    required this.count,
  });

  factory UnreadCountResponseModel.fromJson(Map<String, dynamic> json) {
    final data = NotificationModel.asMap(json['data']);
    return UnreadCountResponseModel(
      success: json['success'] as bool? ?? false,
      count: NotificationModel.parseInt(data?['count']),
    );
  }
}

