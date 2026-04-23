import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

/// Default icon shown in [InvoiceMainCard] when no logo URL is available
/// or when the network image fails to load.
class InvoiceLogoFallback extends StatelessWidget {
  const InvoiceLogoFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.delivery_dining_rounded,
      size: 30,
      color: AppColors.textHint,
    );
  }
}

