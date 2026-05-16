import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../repositories/notifications_repository.dart';

class GetUnreadCountUseCase {
  final NotificationsRepository repository;

  const GetUnreadCountUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getUnreadCount();
  }
}

