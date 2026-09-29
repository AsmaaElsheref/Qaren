class ApiRoutes {
  ApiRoutes._();

  /// Base URL — no trailing slash; Dio BaseOptions uses this as prefix.
  static const String originUrl = 'https://q-test.zynqor.org';
  static const String baseUrl = '$originUrl/api/v3';

  /// Auth endpoints — paths relative to [baseUrl].
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google/token';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyCode = '/auth/verify-code';
  static const String resetPassword = '/auth/reset-password';
  static const String updateProfile = '/auth/update-profile';
  static const String deleteAccount = '/delete/me';

  /// Home endpoints
  static const String categories = '/categories';

  /// Car Rental endpoints
  static const String carRentalSearch = '/cars/search';
  static String carRentalDetails(String carId) =>
      '/cars/${Uri.encodeComponent(carId)}';
  static const String carRentalBook = '/trips/book';
  static const String carRentalProviders = '/providers';
  static const String carRentalAiSearch = '/compare/car-rental/ai-search';

  /// Food delivery endpoints
  static const String foodProducts = '/compare/food-delivery/products';
  static const String foodCategories = '/compare/food-delivery/categories';
  static const String foodCompare = '/food-products/compare';
  static const String foodBooking = '/compare/booking';

  /// Notifications
  static const String notificationsEndpoint = '/notifications';
  static const String unreadCountEndpoint = '/notifications/unread-count';
  static const String readAllEndpoint = '/notifications/read-all';

  /// Booking history
  static const String bookingHistory = '/booking-history';

  /// Wallet
  static const String walletBalance = '/wallet/balance';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletDeposit = '/wallet/deposit';

  /// Legal content
  static const String termsOfUse = '/privacy/types/terms-of-use';

  static String foodInvoiceDetail(int partnerId) =>
      '/food-products/compare/$partnerId';

  /// Resolves a food thumbnail filename (e.g. "classic-burger.jpg") to a
  /// full network URL. Returns the value unchanged if it already looks like
  /// a full URL.
  static String foodImageUrl(String thumbnail) {
    if (thumbnail.isEmpty) return '';
    final uri = Uri.tryParse(thumbnail);
    if (uri != null && uri.hasScheme) return thumbnail;
    return '$originUrl/storage/$thumbnail';
  }
}
