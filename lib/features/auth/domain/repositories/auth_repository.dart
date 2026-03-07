import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/login_params.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(LoginParams params);
  Future<Either<Failure, void>> loginWithBiometrics(UserTypeTab userType);
  Future<Either<Failure, void>> forgotPassword(String email);
}

