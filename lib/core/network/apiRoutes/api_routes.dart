class ApiRoutes {
  ApiRoutes._();

  /// Base URL — no trailing slash; Dio BaseOptions uses this as prefix.
  static const String baseUrl = 'http://qaren.zynqor.org';

  /// Auth endpoints — paths relative to [baseUrl].
  static const String login          = '/api/auth/login';
  static const String register       = '/api/auth/register';
  static const String me             = '/api/auth/me';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String verifyCode     = '/api/auth/verify-code';
  static const String resetPassword  = '/api/auth/reset-password';
  static const String updateProfile  = '/api/auth/update-profile';

  /// Home endpoints
  static const String categories = '/api/categories';

  /// Car Rental endpoints
  static const String carRentalSearch = '/api/compare/car-rental/search';
  static const String carRentalDetails = '/api/compare/car-rental/details'; // /{offer_id}
  static const String carRentalBook = '/api/compare/car-rental/book';

  /// Food delivery endpoints
  static const String foodProducts    = '/api/compare/food-delivery/products';
  static const String foodCategories  = '/api/compare/food-delivery/categories';
  static const String foodCompare     = '/api/food-products/compare';
  static const String foodBooking     = '/api/compare/booking';

  static String foodInvoiceDetail(int partnerId) => '/api/food-products/compare/$partnerId';

  /// Resolves a food thumbnail filename (e.g. "classic-burger.jpg") to a
  /// full network URL. Returns the value unchanged if it already looks like
  /// a full URL.
  static String foodImageUrl(String thumbnail) {
    if (thumbnail.isEmpty) return '';
    final uri = Uri.tryParse(thumbnail);
    if (uri != null && uri.hasScheme) return thumbnail;
    return '$baseUrl/storage/$thumbnail';
  }
}