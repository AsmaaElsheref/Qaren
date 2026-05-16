import 'package:equatable/equatable.dart';

import 'notification_data_entity.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final NotificationDataEntity data;
  final String? readAt;
  final String createdAt;
  final String createdAtLabel;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.data,
    required this.readAt,
    required this.createdAt,
    required this.createdAtLabel,
  });

  bool get isUnread => readAt == null || readAt!.isEmpty;

  NotificationEntity copyAsRead(String readAtValue) {
    return NotificationEntity(
      id: id,
      type: type,
      data: data,
      readAt: readAtValue,
      createdAt: createdAt,
      createdAtLabel: createdAtLabel,
    );
  }

  @override
  List<Object?> get props => [id, type, data, readAt, createdAt, createdAtLabel];
}

