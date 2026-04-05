import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qaren/features/home/data/repositories/home_repository_impl.dart';
import 'package:qaren/features/home/domain/repositories/home_repository.dart';
import 'package:qaren/features/home/domain/usecases/get_categories_usecase.dart';
import 'categories_state.dart';

// ── Data layer ─────────────────────────────────────────────────────────────────
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>(
  (ref) => const HomeRemoteDataSourceImpl(),
);

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider)),
);

// ── Use case ───────────────────────────────────────────────────────────────────
final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>(
  (ref) => GetCategoriesUseCase(ref.watch(homeRepositoryProvider)),
);

// ── Notifier ───────────────────────────────────────────────────────────────────
final categoriesNotifierProvider =
    StateNotifierProvider<CategoriesNotifier, CategoriesState>(
  (ref) => CategoriesNotifier(
    getCategoriesUseCase: ref.watch(getCategoriesUseCaseProvider),
  )..fetchCategories(),
);

class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoriesNotifier({required GetCategoriesUseCase getCategoriesUseCase})
      : _getCategoriesUseCase = getCategoriesUseCase,
        super(const CategoriesState());

  Future<void> fetchCategories({String lang = 'ar'}) async {
    state = state.copyWith(status: CategoriesStatus.loading);

    final result = await _getCategoriesUseCase(lang: lang);

    result.fold(
      (failure) => state = state.copyWith(
        status: CategoriesStatus.failure,
        errorMessage: failure.message,
      ),
      (categories) => state = state.copyWith(
        status: categories.isEmpty
            ? CategoriesStatus.empty
            : CategoriesStatus.success,
        categories: categories,
      ),
    );
  }
}
