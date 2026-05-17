import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors_ext.dart';
import 'profile_stat_item.dart';

class ProfileStatsRow extends StatelessWidget {
  final int ordersCount;
  final int tripsCount;
  final double savingsAmount;
  final String savingsCurrency;

  const ProfileStatsRow({
    super.key,
    required this.ordersCount,
    required this.tripsCount,
    required this.savingsAmount,
    required this.savingsCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final savingsText =
        '${savingsAmount.toStringAsFixed(0)} $savingsCurrency';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileStatItem(value: '$ordersCount', label: 'طلبات'),
        const ProfileStatsDivider(),
        ProfileStatItem(value: '$tripsCount', label: 'رحلات'),
        const ProfileStatsDivider(),
        ProfileStatItem(
          value: savingsText,
          label: 'توفير',
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
    return Container(
      height: 36,
      width: 1,
      color: context.appColors.divider,
    );
  }
}
