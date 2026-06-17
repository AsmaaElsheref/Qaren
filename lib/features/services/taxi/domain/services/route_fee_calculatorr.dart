/// Calculates delivery fee from route distance.
abstract final class RouteFeeCalculator {
  static const double baseFeeSar = 10;
  static const double perKmSar = 2.5;

  static double calculate(double distanceKm) =>
      baseFeeSar + (distanceKm * perKmSar);
}
