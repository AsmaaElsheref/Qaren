import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/icon_container.dart';
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
        padding: const EdgeInsets.all(10),
        child: IconContainer(
          onTap: onBack,
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 16,
            color: AppColors.textPrimary,
          ),
        )
      ),
      // actions: [
      //   TextButton(
      //     onPressed: onEdit,
      //     child: AppText(
      //       'تعديل',
      //       style: AppTextStyles.body.copyWith(
      //         color: AppColors.secondary,
      //         fontWeight: FontWeight.w600,
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}

