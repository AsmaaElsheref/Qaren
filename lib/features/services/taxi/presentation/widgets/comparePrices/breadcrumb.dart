import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';

class Breadcrumb extends StatelessWidget {
  const Breadcrumb({required this.pickup, required this.destination});

  final String pickup;
  final String destination;

  @override
  Widget build(BuildContext context) {
    if (pickup.isEmpty && destination.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: AppText(
            _trimmed(pickup, 'الموقع الحالي'),
            secondary: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: AppDimensions.fontXS),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 10,
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: AppText(
            _trimmed(destination, 'الوجهة'),
            secondary: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: AppDimensions.fontXS),
          ),
        ),
      ],
    );
  }

  String _trimmed(String value, String fallback) => value.isNotEmpty ? value : fallback;
}