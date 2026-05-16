import 'package:intl/intl.dart';

import '../../domain/entities/notification_entity.dart';
import 'notification_data_model.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.data,
    required super.readAt,
    required super.createdAt,
    required super.createdAtLabel,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String? ?? '',
      data: NotificationDataModel.fromJson(asMap(json['data'])),
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      createdAtLabel: formatDate(json['created_at'] as String?),
    );
  }

  static Map<String, dynamic>? asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static int parseInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? fallback;
  }

  static String formatDate(String? value) {
    if (value == null || value.isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return DateFormat('yyyy/MM/dd - hh:mm a').format(parsed.toLocal());
  }
}

