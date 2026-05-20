import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../core/ui/widgets/icon_container.dart';
import '../../food_strings.dart';

class InvoiceHeader extends StatelessWidget {
  const InvoiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        children: [
          IconContainer(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: colors.textPrimary,
            ),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          AppText(
            FoodStrings.invoiceTitle,
            style: TextStyle(
              fontSize: AppDimensions.fontL,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          // IconContainer(
          //   icon: Icon(
          //     Icons.share_outlined,
          //     size: 20,
          //     color: colors.textPrimary,
          //   ),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }
}

