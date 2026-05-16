import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/notifications_remote_datasource.dart';
import '../../data/datasources/notifications_remote_datasource_impl.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notifications_notifier.dart';
import 'notifications_state.dart';

final notificationsRemoteDataSourceProvider = Provider<NotificationsRemoteDataSource>(
  (ref) => const NotificationsRemoteDataSourceImpl(),
);

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepositoryImpl(ref.watch(notificationsRemoteDataSourceProvider)),
);

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>(
  (ref) => GetNotificationsUseCase(ref.watch(notificationsRepositoryProvider)),
);

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>(
  (ref) => GetUnreadCountUseCase(ref.watch(notificationsRepositoryProvider)),
);

final markNotificationReadUseCaseProvider = Provider<MarkNotificationReadUseCase>(
  (ref) => MarkNotificationReadUseCase(ref.watch(notificationsRepositoryProvider)),
);

final markAllNotificationsReadUseCaseProvider = Provider<MarkAllNotificationsReadUseCase>(
  (ref) => MarkAllNotificationsReadUseCase(ref.watch(notificationsRepositoryProvider)),
);

final notificationsProvider = StateNotifierProvider.autoDispose<NotificationsNotifier, NotificationsState>(
  (ref) => NotificationsNotifier(
    getNotificationsUseCase: ref.watch(getNotificationsUseCaseProvider),
    getUnreadCountUseCase: ref.watch(getUnreadCountUseCaseProvider),
    markNotificationReadUseCase: ref.watch(markNotificationReadUseCaseProvider),
    markAllNotificationsReadUseCase: ref.watch(markAllNotificationsReadUseCaseProvider),
  )..loadInitial(),
);

final notificationIdsProvider = Provider<List<String>>(
  (ref) => ref.watch(
    notificationsProvider.select(
      (state) => state.notifications.map((item) => item.id).toList(growable: false),
    ),
  ),
);

final notificationByIdProvider = Provider.family<NotificationEntity?, String>(
  (ref, id) => ref.watch(
    notificationsProvider.select(
      (state) {
        for (final notification in state.notifications) {
          if (notification.id == id) return notification;
        }
        return null;
      },
    ),
  ),
);

final notificationMarkingProvider = Provider.family<bool, String>(
  (ref, id) => ref.watch(
    notificationsProvider.select((state) => state.markingReadIds.contains(id)),
  ),
);

