import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/toast/toast.dart';

import '../providers/wallet_deposit_provider.dart';
import '../providers/wallet_provider.dart';

class WalletDepositButton extends ConsumerWidget {
  const WalletDepositButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(walletDepositProvider.select((state) => state.isLoading));
    final isValid = ref.watch(walletDepositProvider.select((state) => state.isValid));

    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: !isValid || isLoading
            ? null
            : () async {
                final navigator = Navigator.of(context);
                final result = await ref.read(walletDepositProvider.notifier).submit();
                if (result == null) return;
                ref.read(walletProvider.notifier).applyDepositResult(result);
                toast(context: context, msg: 'تم إضافة الرصيد بنجاح',isSuccess: true);
                navigator.pop();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.textHint.withValues(alpha: 0.35),
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
              )
            : const AppText(
                'تأكيد الإيداع',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}

