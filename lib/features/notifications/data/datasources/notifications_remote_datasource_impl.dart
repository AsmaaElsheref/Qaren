import 'package:qaren/core/network/apiRoutes/api_routes.dart';
import 'package:qaren/core/network/dioHelper/dio_helper.dart';

import '../../../../core/utils/print/custom_print.dart';
import '../models/mark_notification_read_response_model.dart';
import '../models/notifications_response_model.dart';
import '../models/unread_count_response_model.dart';
import 'notifications_remote_datasource.dart';

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl();

  @override
  Future<NotificationsResponseModel> getNotifications({required int page}) async {
    final response = await DioHelper.getData(
      url: ApiRoutes.notificationsEndpoint,
      query: <String, dynamic>{'page': page},
    );
    customPrint('Notiii ::: ${response.data}');

    return NotificationsResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<UnreadCountResponseModel> getUnreadCount() async {
    final response = await DioHelper.getData(url: ApiRoutes.unreadCountEndpoint);
    return UnreadCountResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<MarkNotificationReadResponseModel> markNotificationRead({required String notificationId}) async {
    final response = await DioHelper.postData(url: ApiRoutes.notificationsEndpoint+'/$notificationId/read');
    return MarkNotificationReadResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<MarkNotificationReadResponseModel> markAllNotificationsRead() async {
    final response = await DioHelper.postData(url: ApiRoutes.readAllEndpoint);
    return MarkNotificationReadResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}

