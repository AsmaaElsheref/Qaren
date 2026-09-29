import 'package:flutter/material.dart';
import 'package:qaren/core/localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class DeleteAccountMenuItem extends StatelessWidget {
  final VoidCallback onTap;
  final double horizontalPadding;

  const DeleteAccountMenuItem({
    super.key,
    required this.onTap,
    this.horizontalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_forever_outlined,
                size: 21,
                color: AppColors.error,
              ),
            ),
            const SizedBox(width: 14),
            AppText(
              'profile.deleteAccount.title'.tr(),
              style: AppTextStyles.body.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
