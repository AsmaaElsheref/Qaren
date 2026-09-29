import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository _repository;

  const DeleteAccountUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.deleteAccount();
}
