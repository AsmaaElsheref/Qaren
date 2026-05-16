import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/notifications_page_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repository;

  const GetNotificationsUseCase(this.repository);

  Future<Either<Failure, NotificationsPageEntity>> call({required int page}) {
    return repository.getNotifications(page: page);
  }
}

