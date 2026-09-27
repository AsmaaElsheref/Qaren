import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/localization/localized_formatters.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';
import '../../../../core/ui/widgets/saudi_riyal_amount.dart';
import 'profile_stat_item.dart';

class ProfileStatsRow extends StatelessWidget {
  final int ordersCount;
  final int tripsCount;
  final double savingsAmount;

  const ProfileStatsRow({
    super.key,
    required this.ordersCount,
    required this.tripsCount,
    required this.savingsAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileStatItem(
          value: LocalizedFormatters.number(context, ordersCount),
          label: 'profile.stats.orders'.tr(),
        ),
        const ProfileStatsDivider(),
        ProfileStatItem(
          value: LocalizedFormatters.number(context, tripsCount),
          label: 'profile.stats.trips'.tr(),
        ),
        const ProfileStatsDivider(),
        ProfileStatItem(
          value: '',
          valueWidget: SaudiRiyalAmount(
            amount: LocalizedFormatters.number(context, savingsAmount),
            style: AppTextStyles.title.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          label: 'profile.stats.savings'.tr(),
          highlight: true,
        ),
      ],
    );
  }
}

class ProfileStatsDivider extends StatelessWidget {
  const ProfileStatsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 36, width: 1, color: context.appColors.divider);
  }
}
