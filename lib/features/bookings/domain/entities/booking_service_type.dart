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
      BookingServiceType.all => 'الكل',
      BookingServiceType.foodOrder => 'طلبات الطعام',
      BookingServiceType.carRental => 'تأجير السيارات',
      BookingServiceType.unknown => 'خدمة أخرى',
    };
  }

  String get cardLabel {
    return switch (this) {
      BookingServiceType.foodOrder => 'طلب طعام',
      BookingServiceType.carRental => 'تأجير سيارة',
      BookingServiceType.all || BookingServiceType.unknown => 'طلب',
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

