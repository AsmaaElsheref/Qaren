import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/ui/widgets/icon_container.dart';

/// Cart icon with a dollar badge in the header of the cart page.
/// This is static decoration — the live badge count is in the title area.
class CartIconBadge extends StatelessWidget {
  const CartIconBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return IconContainer(
      icon: const Icon(
        Icons.monetization_on_outlined,
        size: 22,
        color: AppColors.primary,
      ),
      onTap: () {},
    );
  }
}

