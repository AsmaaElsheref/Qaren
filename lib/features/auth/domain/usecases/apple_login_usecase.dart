import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AppleLoginUseCase {
  final AuthRepository _repository;

  const AppleLoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() => _repository.loginWithApple();
}
