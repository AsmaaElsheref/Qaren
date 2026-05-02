import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class PersonalProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const PersonalProfileAppBar({
    super.key,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: AppText(
        'ملفي الشخصي',
        style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: TextButton(
          onPressed: onEdit,
          child: AppText(
            'تعديل',
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textPrimary,
              ),
              onPressed: onBack,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}

