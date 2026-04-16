// Re-export for backwards compatibility.
// The real providers live in food_data_providers.dart to avoid circular deps.
export 'food_data_providers.dart'
    show
        foodCategoriesProvider,
        selectedFoodCategoryProvider;
