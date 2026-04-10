import '../../../domain/entities/booking_result_entity.dart';

/// Parses the `data` block from the booking API response.
class BookingResultModel extends BookingResultEntity {
  const BookingResultModel({
    super.id,
    super.userId,
    super.serviceType,
    super.providerSlug,
    super.bookingReference,
    super.status,
    super.sessionId,
    super.bookingDetails,
    super.providerResponse,
    super.createdAt,
    super.updatedAt,
  });

  /// Parses the full API response body `{ "status": true, "data": { ... } }`.
  factory BookingResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return BookingResultModel(
      id: _asInt(data['id']),
      userId: _asInt(data['user_id']),
      serviceType: data['service_type'] as String?,
      providerSlug: data['provider_slug'] as String?,
      bookingReference: data['booking_reference'] as String?,
      status: data['status'] as String?,
      sessionId: data['session_id'] as String?,
      bookingDetails: _parseDetails(data['booking_details']),
      providerResponse: _parseProviderResponse(data['provider_response']),
      createdAt: data['created_at'] as String?,
      updatedAt: data['updated_at'] as String?,
    );
  }

  static BookingDetailsEntity _parseDetails(dynamic raw) {
    if (raw is! Map<String, dynamic>) return const BookingDetailsEntity();
    return BookingDetailsEntity(
      offerId: raw['offer_id'] as String?,
      customerName: raw['customer_name'] as String?,
      customerPhone: raw['customer_phone'] as String?,
    );
  }

  static BookingProviderResponseEntity _parseProviderResponse(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return const BookingProviderResponseEntity();
    }
    return BookingProviderResponseEntity(
      message: raw['message'] as String?,
      simulatedProvider: raw['simulated_provider'] as String?,
    );
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}

