import 'package:equatable/equatable.dart';

class WalletBalanceEntity extends Equatable {
  final int id;
  final double balance;
  final String currency;
  final String updatedAt;
  final String updatedAtLabel;

  const WalletBalanceEntity({
    required this.id,
    required this.balance,
    required this.currency,
    required this.updatedAt,
    required this.updatedAtLabel,
  });

  WalletBalanceEntity copyWith({double? balance}) {
    return WalletBalanceEntity(
      id: id,
      balance: balance ?? this.balance,
      currency: currency,
      updatedAt: updatedAt,
      updatedAtLabel: updatedAtLabel,
    );
  }

  @override
  List<Object?> get props => [id, balance, currency, updatedAt, updatedAtLabel];
}

