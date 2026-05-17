import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors_ext.dart';
import 'icon_container.dart';
import 'AppText.dart';
import 'AppTextStyles.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key, this.title, this.isBack, this.icon});

  final String? title;
  final bool? isBack;
  final IconData? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isBack == true)
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios, color: colors.textPrimary),
                ),
              if (title != null)
                AppText(
                  title!,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                )
              else
                const SizedBox(),
              if (icon != null)
                IconContainer(
                  icon: Icon(icon, color: colors.textPrimary),
                  onTap: () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}
