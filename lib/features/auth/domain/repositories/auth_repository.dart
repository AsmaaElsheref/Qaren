import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:qaren/features/auth/domain/entities/login_params.dart';
import 'package:qaren/features/auth/domain/entities/register_params.dart';
import 'package:qaren/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(LoginParams params);
  Future<Either<Failure, UserEntity>> register(RegisterParams params);
  Future<Either<Failure, UserEntity>> getMe();
  Future<Either<Failure, void>> loginWithBiometrics(UserTypeTab userType);
  Future<Either<Failure, void>> forgotPassword(String email);
}

