import 'package:qaren/core/localization/easy_localization.dart';

import '../../domain/entities/notification_data_entity.dart';
import '../../domain/entities/notification_status.dart';

class NotificationDataModel extends NotificationDataEntity {
  const NotificationDataModel({
    required super.title,
    required super.message,
    required super.status,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic>? json) {
    return NotificationDataModel(
      title: json?['title'] as String? ?? 'notifications.defaultTitle'.tr(),
      message: json?['message'] as String? ?? '',
      status: NotificationStatus.fromApi(json?['status'] as String?),
    );
  }
}
