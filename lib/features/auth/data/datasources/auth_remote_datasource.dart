import 'package:qaren/core/network/apiRoutes/api_routes.dart';
import 'package:qaren/core/network/dioHelper/dio_helper.dart';
import 'package:qaren/core/utils/print/custom_print.dart';
import 'package:qaren/features/auth/domain/entities/login_params.dart';
import 'package:qaren/features/auth/domain/entities/register_params.dart';
import 'package:qaren/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginParams params);
  Future<UserModel> register(RegisterParams params);
  Future<UserModel> getMe();
  Future<void> loginWithBiometrics(UserTypeTab userType);
  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl();

  @override
  Future<UserModel> login(LoginParams params) async {
    try {
      final response = await DioHelper.postData(
        url: ApiRoutes.login,
        data: params.toJson(),
      );
      final body  = response.data as Map<String, dynamic>;
      final data  = body['data']  as Map<String, dynamic>;
      final token = data['token'] as String?;
      final user  = data['user']  as Map<String, dynamic>;

      return UserModel.fromJson(user, token: token);
    }catch (e){
      customPrint('Login Error ===> ${e}');
      throw e;
    }
   
  }

  @override
  Future<UserModel> register(RegisterParams params) async {
    final response = await DioHelper.postData(
      url: ApiRoutes.register,
      data: params.toJson(),
      removeHeader: true
    );

    final body  = response.data as Map<String, dynamic>;
    final data  = body['data']  as Map<String, dynamic>;
    final token = data['token'] as String?;
    final user  = data['user']  as Map<String, dynamic>;

    return UserModel.fromJson(user, token: token);
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await DioHelper.getData(url: ApiRoutes.me);
      final body = response.data as Map<String, dynamic>;
      final user = body['data'] as Map<String, dynamic>;
      return UserModel.fromJson(user);
    } catch (e) {
      customPrint('GetMe Error ===> $e', isError: true);
      rethrow;
    }
  }

  @override
  Future<void> loginWithBiometrics(UserTypeTab userType) async {
    // TODO: implement when backend exposes biometric endpoint
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<void> forgotPassword(String email) async {
    // TODO: implement when backend exposes forgot-password endpoint
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
