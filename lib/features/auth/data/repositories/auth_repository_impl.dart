import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    try {
      final user = await _remoteDataSource.login(params);
      return Either.rightOf(user);
    } on Exception {
      return Either.leftOf(const AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> loginWithBiometrics(
    UserTypeTab userType,
  ) async {
    try {
      await _remoteDataSource.loginWithBiometrics(userType);
      return Either.rightOf(null);
    } on Exception {
      return Either.leftOf(const AuthFailure('فشل التحقق بالبصمة.'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return Either.rightOf(null);
    } on Exception {
      return Either.leftOf(const NetworkFailure());
    }
  }
}
