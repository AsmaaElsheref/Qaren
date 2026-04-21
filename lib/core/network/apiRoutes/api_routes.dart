class ApiRoutes {
  ApiRoutes._();

  /// Base URL — no trailing slash; Dio BaseOptions uses this as prefix.
  static const String baseUrl = 'http://qaren.zynqor.org';

  /// Auth endpoints — paths relative to [baseUrl].
  static const String login    = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String me       = '/api/auth/me';

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
}