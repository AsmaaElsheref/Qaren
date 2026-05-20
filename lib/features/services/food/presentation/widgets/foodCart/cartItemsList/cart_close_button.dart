import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/ui/widgets/icon_container.dart';

/// Close (X) button for the cart page header.
class CartCloseButton extends StatelessWidget {
  const CartCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IconContainer(
      icon: Icon(
        Icons.close_rounded,
        size: 20,
        color: colors.textPrimary,
      ),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}

