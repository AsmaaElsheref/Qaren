import 'package:flutter/material.dart';
import '../../theme/app_colors_ext.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({super.key, required this.icon, required this.onTap});

  final Widget icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colors.border.withValues(alpha: 0.8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: icon,
      ),
    );
  }
}


