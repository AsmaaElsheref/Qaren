import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/booking_details_entity.dart';
import '../repositories/booking_history_repository.dart';

class GetBookingDetailsUseCase {
  final BookingHistoryRepository repository;

  const GetBookingDetailsUseCase(this.repository);

  Future<Either<Failure, BookingDetailsEntity>> call({required int id}) {
    return repository.getBookingDetails(id: id);
  }
}

