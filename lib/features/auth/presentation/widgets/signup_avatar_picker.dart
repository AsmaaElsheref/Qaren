import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

/// Displays a circular avatar preview with a camera-badge tap target.
///
/// - Tapping opens the phone gallery directly.
/// - When an image is already selected, tapping shows a small sheet that
///   allows replacing or removing the current image.
/// - Pure presentational + picker logic only. No Riverpod references here;
///   the parent page handles state updates.
class SignupAvatarPicker extends StatelessWidget {
  final String? imagePath;
  final ValueChanged<String> onImagePicked;
  final VoidCallback onImageRemoved;

  const SignupAvatarPicker({
    super.key,
    this.imagePath,
    required this.onImagePicked,
    required this.onImageRemoved,
  });

  Future<void> _pickFromGallery() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (file != null) onImagePicked(file.path);
  }

  Future<void> _showOptionsSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AvatarOptionsSheet(
        onReplace: () async {
          Navigator.of(context).pop();
          await _pickFromGallery();
        },
        onRemove: () {
          Navigator.of(context).pop();
          onImageRemoved();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double size = 96;
    final colors = context.appColors;
    return GestureDetector(
      onTap: () {
        if (imagePath != null) {
          _showOptionsSheet(context);
        } else {
          _pickFromGallery();
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          // ── Avatar circle ────────────────────────────────────────────
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.disabledBackground,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              image: imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(imagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imagePath == null
                ? const Icon(
                    Icons.person_outline_rounded,
                    size: 44,
                    color: AppColors.textSecondary,
                  )
                : null,
          ),

          // ── Camera badge ─────────────────────────────────────────────
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              size: 15,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Options sheet (shown only when image is already selected) ──────────────────

class AvatarOptionsSheet extends StatelessWidget {
  final VoidCallback onReplace;
  final VoidCallback onRemove;

  const AvatarOptionsSheet({
    super.key,
    required this.onReplace,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Text(
            'صورة الملف الشخصي',
            style: TextStyle(
              fontSize: AppDimensions.fontM,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Replace
          AvatarSheetTile(
            icon: Icons.photo_library_outlined,
            label: 'تغيير الصورة',
            onTap: onReplace,
          ),
          const Divider(height: 1, color: AppColors.border),

          // Remove
          AvatarSheetTile(
            icon: Icons.delete_outline_rounded,
            label: 'إزالة الصورة',
            iconColor: AppColors.error,
            labelColor: AppColors.error,
            onTap: onRemove,
          ),
        ],
      ),
    );
  }
}

class AvatarSheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  const AvatarSheetTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? colors.textPrimary,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: AppDimensions.fontM,
          color: labelColor ?? colors.textPrimary,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}



