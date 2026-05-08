import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../providers/editProfile/edit_profile_provider.dart';

class EditProfileAvatarPicker extends ConsumerWidget {
  final UserEntity providerKey;

  const EditProfileAvatarPicker({
    super.key,
    required this.providerKey,
  });

  Future<void> pickFromGallery(WidgetRef ref) async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 900,
    );
    if (file != null) {
      ref.read(editProfileProvider(providerKey).notifier).updateImage(file.path);
    }
  }

  Future<void> showImageOptions(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const AppText(
              'صورة الملف الشخصي',
              style: TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.textPrimary,
              ),
              title: const AppText('تغيير الصورة'),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                await pickFromGallery(ref);
              },
            ),
            const Divider(height: 1, color: AppColors.border),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              title: const AppText(
                'إزالة الصورة المختارة',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                ref.read(editProfileProvider(providerKey).notifier).updateImage(null);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      editProfileProvider(providerKey).select(
        (value) => (
          imagePath: value.imagePath,
          currentImageUrl: value.currentImageUrl,
        ),
      ),
    );

    return Center(
      child: GestureDetector(
        onTap: () {
          if (state.imagePath != null && state.imagePath!.isNotEmpty) {
            showImageOptions(context, ref);
          } else {
            pickFromGallery(ref);
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariant,
                border: Border.all(color: AppColors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: state.imagePath != null && state.imagePath!.isNotEmpty
                    ? Image.file(File(state.imagePath!), fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: state.currentImageUrl ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: AppColors.textHint,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: AppColors.textHint,
                        ),
                      ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
