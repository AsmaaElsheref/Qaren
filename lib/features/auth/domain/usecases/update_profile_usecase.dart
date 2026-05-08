import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/update_profile_params.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params);
  }
}

