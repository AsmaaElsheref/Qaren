import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../services/serviceProvider/service_provider.dart';
import '../providers/home_providers.dart';
import '../widgets/category_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(filteredCategoriesProvider);
    final serviceRoutes = ref.watch(serviceRoutesProvider);
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.paddingM),
        ),

        // ── Categories grid ────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final category = categories[index];
                final page = serviceRoutes[category.id];
                return CategoryCard(
                  category: category,
                  onTap: page == null
                      ? () {} // service not built yet
                      : () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                  ),
                );
              },
              childCount: categories.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.paddingXL),
        ),
      ],
    );
  }
}
