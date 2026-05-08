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
      BookingStatusFilter.all => 'الكل',
      BookingStatusFilter.pending => 'قيد الانتظار',
      BookingStatusFilter.confirmed => 'مؤكد',
      BookingStatusFilter.cancelled => 'ملغي',
    };
  }
}

