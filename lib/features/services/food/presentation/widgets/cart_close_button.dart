import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/icon_container.dart';

/// Close (X) button for the cart page header.
class CartCloseButton extends StatelessWidget {
  const CartCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconContainer(
      icon: const Icon(
        Icons.close_rounded,
        size: 20,
        color: AppColors.textPrimary,
      ),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}

