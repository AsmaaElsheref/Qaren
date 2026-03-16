import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class SearchLoading extends StatelessWidget {
  const SearchLoading({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 98,
          height: 98,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        ClipOval(
          child: SizedBox(
            width: 86,
            height: 86,
            child: Icon(Icons.search,color: AppColors.primary,size: 40,),
          ),
        ),
        SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }
}