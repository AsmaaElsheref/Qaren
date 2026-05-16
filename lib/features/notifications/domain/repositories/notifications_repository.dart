import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/notifications_page_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificationsPageEntity>> getNotifications({required int page});

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, bool>> markNotificationRead({required String notificationId});

  Future<Either<Failure, bool>> markAllNotificationsRead();
}

