import 'package:dio/dio.dart';
import 'package:qaren/core/network/apiRoutes/api_routes.dart';
import 'package:qaren/core/network/dioHelper/dio_helper.dart';
import 'package:qaren/core/utils/print/custom_print.dart';
import 'package:qaren/features/auth/domain/entities/login_params.dart';
import 'package:qaren/features/auth/domain/entities/register_params.dart';
import 'package:qaren/features/auth/domain/entities/update_profile_params.dart';
import 'package:qaren/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginParams params);
  Future<UserModel> register(RegisterParams params);
  Future<UserModel> getMe();
  Future<UserModel> updateProfile(UpdateProfileParams params);
  Future<void> loginWithBiometrics(UserTypeTab userType);
  Future<void> forgotPassword(String login);
  Future<void> verifyCode(String login, String code);
  Future<void> resetPassword(String login, String code, String password, String passwordConfirmation);
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
    // Build FormData — always multipart so the server accepts `image` as a file.
    final fields = params.toFields();
    final formDataMap = <String, dynamic>{...fields};

    if (params.imagePath != null && params.imagePath!.isNotEmpty) {
      formDataMap['image'] = await MultipartFile.fromFile(
        params.imagePath!,
        filename: params.imagePath!.split('/').last,
      );
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await DioHelper.postData(
      url: ApiRoutes.register,
      data: formData,
      removeHeader: true,
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
  Future<UserModel> updateProfile(UpdateProfileParams params) async {
    final formDataMap = <String, dynamic>{...params.toFields()};

    if (params.imagePath != null && params.imagePath!.isNotEmpty) {
      formDataMap['image'] = await MultipartFile.fromFile(
        params.imagePath!,
        filename: params.imagePath!.split('/').last,
      );
    }

    final response = await DioHelper.postData(
      url: ApiRoutes.updateProfile,
      data: FormData.fromMap(formDataMap),
    );

    final body = response.data as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  @override
  Future<void> loginWithBiometrics(UserTypeTab userType) async {
    // TODO: implement when backend exposes biometric endpoint
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<void> forgotPassword(String login) async {
    await DioHelper.postData(
      url: ApiRoutes.forgotPassword,
      data: {'login': login},
    );
  }

  @override
  Future<void> verifyCode(String login, String code) async {
    await DioHelper.postData(
      url: ApiRoutes.verifyCode,
      data: {'login': login, 'code': int.parse(code)},
    );
  }

  @override
  Future<void> resetPassword(
    String login,
    String code,
    String password,
    String passwordConfirmation,
  ) async {
    await DioHelper.postData(
      url: ApiRoutes.resetPassword,
      data: {
        'login': login,
        'code': int.parse(code),
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }
}
