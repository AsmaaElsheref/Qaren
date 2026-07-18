import 'package:qaren/core/localization/easy_localization.dart';

enum NotificationStatus {
  confirmed,
  info,
  pending,
  cancelled,
  failed,
  unknown;

  String get label {
    return switch (this) {
      NotificationStatus.confirmed => 'notifications.status.confirmed'.tr(),
      NotificationStatus.info => 'notifications.status.info'.tr(),
      NotificationStatus.pending => 'notifications.status.pending'.tr(),
      NotificationStatus.cancelled => 'notifications.status.cancelled'.tr(),
      NotificationStatus.failed => 'notifications.status.failed'.tr(),
      NotificationStatus.unknown => 'notifications.status.notification'.tr(),
    };
  }

  static NotificationStatus fromApi(String? value) {
    return switch (value) {
      'confirmed' => NotificationStatus.confirmed,
      'info' => NotificationStatus.info,
      'pending' => NotificationStatus.pending,
      'cancelled' => NotificationStatus.cancelled,
      'canceled' => NotificationStatus.cancelled,
      'failed' => NotificationStatus.failed,
      _ => NotificationStatus.unknown,
    };
  }
}
