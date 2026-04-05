  import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/utils/either.dart';
import 'package:qaren/features/auth/domain/entities/register_params.dart';
import 'package:qaren/features/auth/domain/entities/user_entity.dart';
import 'package:qaren/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _repository.register(params);
  }
}

