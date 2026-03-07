import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/login_params.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.login(params);
  }
}

