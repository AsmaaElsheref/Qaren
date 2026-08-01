import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository _repository;

  const GoogleLoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() {
    return _repository.loginWithGoogle();
  }
}
