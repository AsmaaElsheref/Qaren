import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../repositories/notifications_repository.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationsRepository repository;

  const MarkAllNotificationsReadUseCase(this.repository);

  Future<Either<Failure, bool>> call() {
    return repository.markAllNotificationsRead();
  }
}

