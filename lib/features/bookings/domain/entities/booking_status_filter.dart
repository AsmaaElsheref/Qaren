import 'package:qaren/core/localization/easy_localization.dart';

enum BookingStatusFilter {
  all,
  pending,
  confirmed,
  cancelled;

  String? get queryValue {
    return switch (this) {
      BookingStatusFilter.all => null,
      BookingStatusFilter.pending => 'pending',
      BookingStatusFilter.confirmed => 'confirmed',
      BookingStatusFilter.cancelled => 'cancelled',
    };
  }

  String get label {
    return switch (this) {
      BookingStatusFilter.all => 'bookings.serviceType.all'.tr(),
      BookingStatusFilter.pending => 'bookings.status.pending'.tr(),
      BookingStatusFilter.confirmed => 'bookings.status.confirmed'.tr(),
      BookingStatusFilter.cancelled => 'bookings.status.cancelled'.tr(),
    };
  }
}
