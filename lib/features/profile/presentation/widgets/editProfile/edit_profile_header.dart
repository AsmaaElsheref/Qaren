import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../../../../core/ui/widgets/AppTextStyles.dart';

class EditProfileHeader extends StatelessWidget {
  final VoidCallback onBack;

  const EditProfileHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.textPrimary,
          ),
          const Expanded(
            child: AppText(
              'تعديل الملف الشخصي',
              textAlign: TextAlign.center,
              style: AppTextStyles.title,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

