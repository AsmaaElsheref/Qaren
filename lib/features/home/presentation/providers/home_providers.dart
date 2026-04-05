import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/features/home/presentation/pages/home_view.dart';
import '../../domain/entities/category_entity.dart';
import 'categories_providers.dart';

// ── Search query provider ─────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

// ── Filtered categories provider ──────────────────────────────────────────────
// Derives from the real API state — only rebuilds when categories or query change.
final filteredCategoriesProvider = Provider<List<CategoryEntity>>((ref) {
  final categoriesState = ref.watch(categoriesNotifierProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  final all = categoriesState.categories;
  if (query.isEmpty) return all;

  return all
      .where((c) =>
          c.name.toLowerCase().contains(query) ||
          c.description.toLowerCase().contains(query))
      .toList();
});

// ── Bottom nav index provider ─────────────────────────────────────────────────
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

final navigationScreens = Provider<List<Widget>>(
  (ref) => [
    const HomeView(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ],
);
