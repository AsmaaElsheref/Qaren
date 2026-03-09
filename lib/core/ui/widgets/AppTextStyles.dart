import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    fontFamily: 'Cairo',
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: 'Cairo',
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontFamily: 'Cairo',
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontFamily: 'Cairo',
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 1.4,
    fontFamily: 'Cairo',
    color: AppColors.textSecondary,
  );
}
