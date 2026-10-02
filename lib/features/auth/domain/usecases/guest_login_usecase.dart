import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/guest_auth_data.dart';
import '../repositories/auth_repository.dart';

class GuestLoginUseCase {
  final AuthRepository _repository;

  const GuestLoginUseCase(this._repository);

  Future<Either<Failure, GuestAuthData>> call() {
    return _repository.continueAsGuest();
  }
}
