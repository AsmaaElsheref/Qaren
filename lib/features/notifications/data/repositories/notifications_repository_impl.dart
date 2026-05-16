import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';
import 'package:qaren/core/utils/print/custom_print.dart';

import '../../domain/entities/notifications_page_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  const NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, NotificationsPageEntity>> getNotifications({required int page}) async {
    try {
      final response = await remoteDataSource.getNotifications(page: page);
      return Either.rightOf(response.page);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final response = await remoteDataSource.getUnreadCount();
      return Either.rightOf(response.count);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markNotificationRead({required String notificationId}) async {
    try {
      final response = await remoteDataSource.markNotificationRead(notificationId: notificationId);
      return Either.rightOf(response.success);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllNotificationsRead() async {
    try {
      final response = await remoteDataSource.markAllNotificationsRead();
      return Either.rightOf(response.success);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }
}

