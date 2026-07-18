import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/localization/easy_localization.dart';

enum BookingServiceType {
  all,
  foodOrder,
  carRental,
  unknown;

  String? get queryValue {
    return switch (this) {
      BookingServiceType.all => null,
      BookingServiceType.foodOrder => 'food_order',
      BookingServiceType.carRental => 'car_rental',
      BookingServiceType.unknown => null,
    };
  }

  String get label {
    return switch (this) {
      BookingServiceType.all => 'bookings.serviceType.all'.tr(),
      BookingServiceType.foodOrder => 'bookings.serviceType.food'.tr(),
      BookingServiceType.carRental => 'bookings.serviceType.carRental'.tr(),
      BookingServiceType.unknown => 'bookings.serviceType.other'.tr(),
    };
  }

  String get cardLabel {
    return switch (this) {
      BookingServiceType.foodOrder => 'bookings.serviceType.foodCard'.tr(),
      BookingServiceType.carRental => 'bookings.serviceType.carCard'.tr(),
      BookingServiceType.all ||
      BookingServiceType.unknown => 'bookings.serviceType.genericCard'.tr(),
    };
  }

  static BookingServiceType fromApi(String? value) {
    return switch (value) {
      'food_order' => BookingServiceType.foodOrder,
      'car_rental' => BookingServiceType.carRental,
      null || '' => BookingServiceType.unknown,
      _ => BookingServiceType.unknown,
    };
  }
}
