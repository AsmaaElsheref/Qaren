import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/localStorage/cache_helper.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../auth/domain/entities/update_profile_params.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../../auth/domain/usecases/update_profile_usecase.dart';
import '../../../../auth/presentation/providers/login_providers.dart';
import '../../../../auth/presentation/providers/user_profile_provider.dart';
import 'edit_profile_state.dart';

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
  (ref) => UpdateProfileUseCase(ref.watch(authRepositoryProvider)),
);

final editProfileProvider = StateNotifierProvider.autoDispose
    .family<EditProfileNotifier, EditProfileState, UserEntity>(
  (ref, user) => EditProfileNotifier(
    ref: ref,
    initialUser: user,
    updateProfileUseCase: ref.watch(updateProfileUseCaseProvider),
  ),
);

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final Ref _ref;
  final UpdateProfileUseCase _updateProfileUseCase;

  EditProfileNotifier({
    required Ref ref,
    required UserEntity initialUser,
    required UpdateProfileUseCase updateProfileUseCase,
  })  : _ref = ref,
        _updateProfileUseCase = updateProfileUseCase,
        super(EditProfileState.fromUser(initialUser));

  void updateName(String value) {
    state = state.copyWith(name: value, status: EditProfileStatus.initial);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value, status: EditProfileStatus.initial);
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value, status: EditProfileStatus.initial);
  }

  void updateGender(String value) {
    state = state.copyWith(gender: value, status: EditProfileStatus.initial);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, status: EditProfileStatus.initial);
  }

  void updatePasswordConfirmation(String value) {
    state = state.copyWith(
      passwordConfirmation: value,
      status: EditProfileStatus.initial,
    );
  }

  void updateImage(String? path) {
    state = path == null
        ? state.copyWith(clearImage: true, status: EditProfileStatus.initial)
        : state.copyWith(imagePath: path, status: EditProfileStatus.initial);
  }

  Future<void> submit() async {
    final validationMessage = validate();
    if (validationMessage != null) {
      state = state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: validationMessage,
      );
      return;
    }

    state = state.copyWith(status: EditProfileStatus.loading, errorMessage: null);

    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        name: state.name.trim(),
        email: state.email.trim(),
        phone: state.phone.trim(),
        gender: state.gender,
        password: state.password.trim().isEmpty ? null : state.password,
        passwordConfirmation: state.password.trim().isEmpty
            ? null
            : state.passwordConfirmation,
        imagePath: state.imagePath,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: failure.message,
        );
      },
      (user) async {
        await CacheHelper.saveData(key: AppConstants.userName, value: user.name);
        await CacheHelper.saveData(key: AppConstants.userEmail, value: user.email);
        await CacheHelper.saveData(key: AppConstants.userPhone, value: user.phone);
        _ref.invalidate(userProfileProvider);
        state = state.copyWith(
          status: EditProfileStatus.success,
          updatedUser: user,
          currentImageUrl: user.image,
          clearImage: true,
        );
      },
    );
  }

  String? validate() {
    return Validators.validateName(state.name) ??
        Validators.validateEmail(state.email) ??
        Validators.validatePhone(state.phone) ??
        validatePasswordFields();
  }

  String? validatePasswordFields() {
    if (state.password.trim().isEmpty &&
        state.passwordConfirmation.trim().isEmpty) {
      return null;
    }

    if (state.password.length < 8) {
      return 'كلمة المرور يجب ألا تقل عن 8 أحرف';
    }

    if (state.password != state.passwordConfirmation) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return null;
  }
}

