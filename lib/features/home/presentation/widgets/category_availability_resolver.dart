/// Single source of truth for which category types are currently active.
/// All logic lives here — no business rules inside widgets.
class CategoryAvailabilityResolver {
  CategoryAvailabilityResolver._();

  static const _enabledTypes = {'taxi', 'food_delivery','car_rental'};

  static bool isEnabled(String type) => _enabledTypes.contains(type);
}

