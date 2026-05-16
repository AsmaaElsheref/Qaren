enum NotificationStatus {
  confirmed,
  info,
  pending,
  cancelled,
  failed,
  unknown;

  String get label {
    return switch (this) {
      NotificationStatus.confirmed => 'مؤكد',
      NotificationStatus.info => 'معلومة',
      NotificationStatus.pending => 'قيد الانتظار',
      NotificationStatus.cancelled => 'ملغي',
      NotificationStatus.failed => 'فشل',
      NotificationStatus.unknown => 'إشعار',
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

