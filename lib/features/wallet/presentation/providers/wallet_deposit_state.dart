import 'package:equatable/equatable.dart';

class WalletDepositState extends Equatable {
  final String amount;
  final bool isLoading;
  final String? errorMessage;

  const WalletDepositState({
    this.amount = '',
    this.isLoading = false,
    this.errorMessage,
  });

  double? get amountValue => double.tryParse(amount.trim());

  bool get isValid => amountValue != null && amountValue! > 0;

  WalletDepositState copyWith({
    String? amount,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WalletDepositState(
      amount: amount ?? this.amount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [amount, isLoading, errorMessage];
}

