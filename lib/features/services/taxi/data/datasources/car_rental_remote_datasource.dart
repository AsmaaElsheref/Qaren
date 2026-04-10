import '../../../../../core/network/apiRoutes/api_routes.dart';
import '../../../../../core/network/dioHelper/dio_helper.dart';
import '../../../../../core/utils/print/custom_print.dart';
import '../../domain/entities/book_car_rental_params.dart';
import '../../domain/entities/car_rental_search_params.dart';
import '../models/booking/booking_result_model.dart';
import '../models/carRental/car_rental_search_result_model.dart';
import '../models/offerDetails/offer_details_model.dart';

abstract class CarRentalRemoteDataSource {
  Future<CarRentalSearchResultModel> searchOffers(
    CarRentalSearchParams params,
  );

  Future<OfferDetailsModel> getOfferDetails(String offerId);

  Future<BookingResultModel> bookOffer(BookCarRentalParams params);
}

class CarRentalRemoteDataSourceImpl implements CarRentalRemoteDataSource {
  const CarRentalRemoteDataSourceImpl();

  @override
  Future<CarRentalSearchResultModel> searchOffers(
    CarRentalSearchParams params,
  ) async {
    try {
      final response = await DioHelper.getData(
        url: ApiRoutes.carRentalSearch,
        query: params.toQueryParameters(),
      );

      final body = response.data as Map<String, dynamic>;
      return CarRentalSearchResultModel.fromJson(body);
    } catch (e) {
      customPrint('CarRental search error ===> $e', isError: true);
      rethrow;
    }
  }

  @override
  Future<OfferDetailsModel> getOfferDetails(String offerId) async {
    try {
      final response = await DioHelper.getData(
        url: '${ApiRoutes.carRentalDetails}/$offerId',
      );

      final body = response.data as Map<String, dynamic>;
      return OfferDetailsModel.fromJson(body);
    } catch (e) {
      customPrint('Offer details error ===> $e', isError: true);
      rethrow;
    }
  }

  @override
  Future<BookingResultModel> bookOffer(BookCarRentalParams params) async {
    try {
      final response = await DioHelper.postData(
        url: ApiRoutes.carRentalBook,
        data: params.toJson(),
      );

      final body = response.data as Map<String, dynamic>;
      return BookingResultModel.fromJson(body);
    } catch (e) {
      customPrint('Booking error ===> $e', isError: true);
      rethrow;
    }
  }
}

