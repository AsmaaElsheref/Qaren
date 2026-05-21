import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../providers/editProfile/edit_profile_provider.dart';

class EditProfileGenderSelector extends ConsumerWidget {
  final UserEntity providerKey;

  const EditProfileGenderSelector({
    super.key,
    required this.providerKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final selectedGender = ref.watch(
      editProfileProvider(providerKey).select((state) => state.gender),
    );
    final notifier = ref.read(editProfileProvider(providerKey).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppText(
          AppStrings.genderHint,
          style: TextStyle(
            fontSize: AppDimensions.fontS,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => notifier.updateGender('male'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: AppDimensions.inputHeight,
                  decoration: BoxDecoration(
                    color: selectedGender == 'male'
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : colors.surface,
                    border: Border.all(
                      color: selectedGender == 'male'
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.male_rounded,
                        color: selectedGender == 'male'
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      AppText(
                        AppStrings.genderMale,
                        style: TextStyle(
                          color: selectedGender == 'male'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: GestureDetector(
                onTap: () => notifier.updateGender('female'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: AppDimensions.inputHeight,
                  decoration: BoxDecoration(
                    color: selectedGender == 'female'
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : colors.surface,
                    border: Border.all(
                      color: selectedGender == 'female'
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.female_rounded,
                        color: selectedGender == 'female'
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      AppText(
                        AppStrings.genderFemale,
                        style: TextStyle(
                          color: selectedGender == 'female'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

