import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// Shows a brief floating [SnackBar]-style notification.
///
/// Pass [isError] = true for error styling, [isSuccess] = true for success styling.
/// Requires a valid [BuildContext] with a [ScaffoldMessenger] ancestor.
void toast({
  required BuildContext context,
  required String msg,
  bool isError = false,
  bool isSuccess = false,
}) {
  final backgroundColor = isError
      ? AppColors.error
      : isSuccess
          ? AppColors.primary
          : AppColors.textPrimary;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: AppColors.white, fontSize: 14),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
}