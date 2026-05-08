import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../../../core/utils/print/custom_print.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_me_usecase.dart';
import 'login_providers.dart';

// ── Use case provider ──────────────────────────────────────────────────────────
final getMeUseCaseProvider = Provider<GetMeUseCase>(
  (ref) => GetMeUseCase(ref.watch(authRepositoryProvider)),
);

// ── User profile provider ──────────────────────────────────────────────────────
/// Fetches the logged-in user from the API and returns [UserEntity].
/// Also persists name/email/phone in [CacheHelper] as a side-effect.
final userProfileProvider = FutureProvider.autoDispose<UserEntity>((ref) async {
  final getMe = ref.read(getMeUseCaseProvider);
  final result = await getMe();

  return result.fold(
    (failure) {
      customPrint(
        'UserProfile: failed to fetch me — ${failure.message}',
        isError: true,
      );
      throw Exception(failure.message);
    },
    (user) async {
      await CacheHelper.saveData(key: AppConstants.userName, value: user.name);
      await CacheHelper.saveData(key: AppConstants.userEmail, value: user.email);
      await CacheHelper.saveData(key: AppConstants.userPhone, value: user.phone);
      customPrint('UserProfile: fetched name=${user.name} phone=${user.phone}');
      return user;
    },
  );
});

