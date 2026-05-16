import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../repositories/notifications_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationsRepository repository;

  const MarkNotificationReadUseCase(this.repository);

  Future<Either<Failure, bool>> call({required String notificationId}) {
    return repository.markNotificationRead(notificationId: notificationId);
  }
}

