import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_deposit_result_entity.dart';
import '../../domain/usecases/deposit_wallet_amount_usecase.dart';
import 'wallet_deposit_state.dart';
import 'wallet_provider.dart';

final walletDepositProvider = StateNotifierProvider.autoDispose<WalletDepositNotifier, WalletDepositState>(
  (ref) => WalletDepositNotifier(
    depositWalletAmountUseCase: ref.watch(depositWalletAmountUseCaseProvider),
  ),
);

class WalletDepositNotifier extends StateNotifier<WalletDepositState> {
  final DepositWalletAmountUseCase depositWalletAmountUseCase;

  WalletDepositNotifier({required this.depositWalletAmountUseCase})
      : super(const WalletDepositState());

  void updateAmount(String value) {
    state = state.copyWith(amount: value, clearError: true);
  }

  void selectQuickAmount(double amount) {
    state = state.copyWith(amount: amount.toStringAsFixed(0), clearError: true);
  }

  Future<WalletDepositResultEntity?> submit() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'برجاء إدخال مبلغ صحيح أكبر من صفر');
      return null;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await depositWalletAmountUseCase(amount: state.amountValue!);

    if (!mounted) return null;

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return null;
      },
      (depositResult) {
        state = const WalletDepositState();
        return depositResult;
      },
    );
  }
}

