import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
import '../../providers/editProfile/edit_profile_provider.dart';

class EditProfileSaveButton extends ConsumerWidget {
  final UserEntity providerKey;

  const EditProfileSaveButton({
    super.key,
    required this.providerKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      editProfileProvider(providerKey).select((state) => state.isLoading),
    );

    return AppButton(
      label: 'حفظ التغييرات',
      icon: Icons.check_rounded,
      isLoading: isLoading,
      onTap: () => ref.read(editProfileProvider(providerKey).notifier).submit(),
    );
  }
}

