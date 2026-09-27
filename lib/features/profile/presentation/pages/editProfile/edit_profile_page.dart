import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/toast/toast.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../providers/editProfile/edit_profile_provider.dart';
import '../../providers/editProfile/edit_profile_state.dart';
import '../../widgets/editProfile/edit_profile_avatar_picker.dart';
import '../../widgets/editProfile/edit_profile_gender_selector.dart';
import '../../widgets/editProfile/edit_profile_header.dart';
import '../../widgets/editProfile/edit_profile_input_field.dart';
import '../../widgets/editProfile/edit_profile_save_button.dart';

class EditProfilePage extends ConsumerWidget {
  final UserEntity user;

  const EditProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<EditProfileState>(editProfileProvider(user), (previous, next) {
      if (previous?.status == next.status) return;

      if (next.status == EditProfileStatus.failure &&
          next.errorMessage != null) {
        toast(context: context, msg: next.errorMessage!, isError: true);
      }

      if (next.status == EditProfileStatus.success) {
        toast(
          context: context,
          msg: 'profile.editSuccess'.tr(),
          isSuccess: true,
        );
        Navigator.of(context).pop(next.updatedUser);
      }
    });

    final notifier = ref.read(editProfileProvider(user).notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EditProfileAvatarPicker(providerKey: user),
                    const SizedBox(height: 28),
                    EditProfileInputField(
                      label: 'profile.field.fullName'.tr(),
                      initialValue: user.name,
                      icon: Icons.person_outline_rounded,
                      onChanged: notifier.updateName,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    EditProfileInputField(
                      label: 'profile.field.email'.tr(),
                      initialValue: user.email,
                      icon: Icons.mail_outline_rounded,
                      onChanged: notifier.updateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    EditProfileInputField(
                      label: 'profile.field.phone'.tr(),
                      initialValue: user.phone,
                      icon: Icons.phone_outlined,
                      onChanged: notifier.updatePhone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    EditProfileGenderSelector(providerKey: user),
                    const SizedBox(height: 16),
                    EditProfileInputField(
                      label: 'profile.field.newPassword'.tr(),
                      initialValue: '',
                      icon: Icons.lock_outline_rounded,
                      onChanged: notifier.updatePassword,
                      obscureText: true,
                      hintText: 'profile.field.passwordOptionalHint'.tr(),
                    ),
                    const SizedBox(height: 16),
                    EditProfileInputField(
                      label: 'profile.field.confirmPassword'.tr(),
                      initialValue: '',
                      icon: Icons.lock_reset_rounded,
                      onChanged: notifier.updatePasswordConfirmation,
                      obscureText: true,
                    ),
                    const SizedBox(height: 28),
                    EditProfileSaveButton(providerKey: user),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
