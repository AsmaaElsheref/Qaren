import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class DeleteAccountConfirmationSheet extends StatefulWidget {
  /// Returns null on success, or a localized error message on failure.
  final Future<String?> Function() onConfirm;

  const DeleteAccountConfirmationSheet({super.key, required this.onConfirm});

  @override
  State<DeleteAccountConfirmationSheet> createState() =>
      _DeleteAccountConfirmationSheetState();
}

class _DeleteAccountConfirmationSheetState
    extends State<DeleteAccountConfirmationSheet> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _confirmDelete() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final errorMessage = await widget.onConfirm();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'profile.deleteAccount.failed'.tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: BoxDecoration(
          color: colors.bottomSheetBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever_outlined,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            AppText(
              'profile.deleteAccount.confirmTitle'.tr(),
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AppText(
              'profile.deleteAccount.confirmMessage'.tr(),
              secondary: true,
              textAlign: TextAlign.center,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              AppText(
                _errorMessage!,
                style: AppTextStyles.body.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.white,
                        ),
                      )
                    : AppText(
                        'profile.deleteAccount.confirmButton'.tr(),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.textPrimary,
                  side: BorderSide(color: colors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: AppText(
                  'common.cancel'.tr(),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
