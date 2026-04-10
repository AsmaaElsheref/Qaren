import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../../../core/utils/print/custom_print.dart';
import '../../domain/usecases/get_me_usecase.dart';
import 'login_providers.dart';

// ── Use case provider ──────────────────────────────────────────────────────────
final getMeUseCaseProvider = Provider<GetMeUseCase>(
  (ref) => GetMeUseCase(ref.watch(authRepositoryProvider)),
);

// ── User profile notifier ──────────────────────────────────────────────────────
/// Fetches the logged-in user from the API when the cached name is missing,
/// then persists the result in [CacheHelper] so the rest of the app can read
/// name / phone synchronously without an extra network call.
final userProfileProvider = FutureProvider<void>((ref) async {
  final cachedName =
      CacheHelper.getData(key: AppConstants.userName) as String?;

  // Already have the name cached — nothing to do.
  if (cachedName != null && cachedName.isNotEmpty) return;

  final getMe = ref.read(getMeUseCaseProvider);
  final result = await getMe();

  result.fold(
    (failure) => customPrint(
      'UserProfile: failed to fetch me — ${failure.message}',
      isError: true,
    ),
    (user) async {
      await CacheHelper.saveData(
        key: AppConstants.userName,
        value: user.name,
      );
      await CacheHelper.saveData(
        key: AppConstants.userPhone,
        value: user.phone,
      );
      customPrint('UserProfile: cached name=${user.name} phone=${user.phone}');
    },
  );
});

