import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';
import '../providers/auth_session_provider.dart';

enum _GuestAccessAction { login, register }

/// Single entry point for operations that require a customer account.
class GuestAccessGuard {
  GuestAccessGuard._();

  static Future<bool> ensureAuthenticated({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    if (ref.read(authSessionProvider).isAuthenticated) return true;

    final action = await showDialog<_GuestAccessAction>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        content: AppText(
          'auth.login_required'.tr(),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: AppText('auth.cancel'.tr()),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_GuestAccessAction.register),
            child: AppText('auth.create_account'.tr()),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_GuestAccessAction.login),
            child: AppText(
              'auth.login_action'.tr(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (!context.mounted || action == null) return false;

    final page = switch (action) {
      _GuestAccessAction.login => const LoginPage(),
      _GuestAccessAction.register => const SignupPage(),
    };
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => page));
    return false;
  }
}
