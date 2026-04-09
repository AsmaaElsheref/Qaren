class ApiRoutes {
  ApiRoutes._();

  /// Base URL — no trailing slash; Dio BaseOptions uses this as prefix.
  static const String baseUrl = 'http://qaren.zynqor.org';

  /// Auth endpoints — paths relative to [baseUrl].
  static const String login    = '/api/auth/login';
  static const String register = '/api/auth/registerContinue';

  /// Home endpoints
  static const String categories = '/api/categories';

  /// Car Rental endpoints
  static const String carRentalSearch = '/api/compare/car-rental/search';
}