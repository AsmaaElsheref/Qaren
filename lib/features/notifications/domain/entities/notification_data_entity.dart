import 'package:equatable/equatable.dart';

import 'notification_status.dart';

class NotificationDataEntity extends Equatable {
  final String title;
  final String message;
  final NotificationStatus status;

  const NotificationDataEntity({
    required this.title,
    required this.message,
    required this.status,
  });

  @override
  List<Object?> get props => [title, message, status];
}

