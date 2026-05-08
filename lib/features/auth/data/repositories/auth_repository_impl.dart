import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:qaren/features/auth/domain/entities/login_params.dart';
import 'package:qaren/features/auth/domain/entities/register_params.dart';
import 'package:qaren/features/auth/domain/entities/update_profile_params.dart';
import 'package:qaren/features/auth/domain/entities/user_entity.dart';
import 'package:qaren/features/auth/domain/repositories/auth_repository.dart';
import 'package:qaren/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    try {
      final user = await _remoteDataSource.login(params);
      return Either.rightOf(user);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(const AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(RegisterParams params) async {
    try {
      final user = await _remoteDataSource.register(params);
      return Either.rightOf(user);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(const AuthFailure('فشل إنشاء الحساب. حاول مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    try {
      final user = await _remoteDataSource.getMe();
      return Either.rightOf(user);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(const AuthFailure('فشل جلب بيانات المستخدم.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    try {
      final user = await _remoteDataSource.updateProfile(params);
      return Either.rightOf(user);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(const AuthFailure('فشل تحديث بيانات الملف الشخصي.'));
    }
  }

  @override
  Future<Either<Failure, void>> loginWithBiometrics(
    UserTypeTab userType,
  ) async {
    try {
      await _remoteDataSource.loginWithBiometrics(userType);
      return Either.rightOf(null);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(const AuthFailure('فشل التحقق بالبصمة.'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String login) async {
    try {
      await _remoteDataSource.forgotPassword(login);
      return Either.rightOf(null);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(const NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyCode(String login, String code) async {
    try {
      await _remoteDataSource.verifyCode(login, code);
      return Either.rightOf(null);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(const ServerFailure('الكود غير صحيح. حاول مجدداً.'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String login,
    String code,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      await _remoteDataSource.resetPassword(login, code, password, passwordConfirmation);
      return Either.rightOf(null);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(const ServerFailure('فشل تغيير كلمة المرور. حاول مجدداً.'));
    }
  }
}

