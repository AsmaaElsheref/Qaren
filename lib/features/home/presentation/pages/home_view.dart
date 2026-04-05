import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../services/serviceProvider/service_provider.dart';
import '../providers/categories_providers.dart';
import '../providers/categories_state.dart';
import '../providers/home_providers.dart';
import '../widgets/category_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesNotifierProvider);

    return switch (categoriesState.status) {
      CategoriesStatus.loading || CategoriesStatus.initial => const _LoadingGrid(),
      CategoriesStatus.failure  => _ErrorView(
          message: categoriesState.errorMessage,
          onRetry: () => ref
              .read(categoriesNotifierProvider.notifier)
              .fetchCategories(),
        ),
      CategoriesStatus.empty    => const _EmptyView(),
      CategoriesStatus.success  => const _CategoriesGrid(),
    };
  }
}

// ── Success grid ───────────────────────────────────────────────────────────────

class _CategoriesGrid extends ConsumerWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories  = ref.watch(filteredCategoriesProvider);
    final serviceRoutes = ref.watch(serviceRoutesProvider);

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.paddingM)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = categories[index];
                final page     = serviceRoutes[category.type];
                return CategoryCard(
                  category: category,
                  onTap: page == null
                      ? () {}
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => page),
                          ),
                );
              },
              childCount: categories.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:  2,
              crossAxisSpacing: 12,
              mainAxisSpacing:  12,
              childAspectRatio: 1.8,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.paddingXL)),
      ],
    );
  }
}

// ── Loading skeleton ───────────────────────────────────────────────────────────

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.paddingM)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (_, __) => const _SkeletonCard(),
              childCount: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:  2,
              crossAxisSpacing: 12,
              mainAxisSpacing:  12,
              childAspectRatio: 1.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_off_outlined, size: 48, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'لا توجد تصنيفات متاحة',
            style: TextStyle(
              fontSize: AppDimensions.fontM,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error state ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              message ?? 'حدث خطأ. يرجى المحاولة مرة أخرى.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
