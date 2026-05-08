import 'package:intl/intl.dart';

import '../../domain/entities/wallet_balance_entity.dart';

class WalletBalanceModel extends WalletBalanceEntity {
  const WalletBalanceModel({
    required super.id,
    required super.balance,
    required super.currency,
    required super.updatedAt,
    required super.updatedAtLabel,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      id: parseInt(json['id']) ?? 0,
      balance: parseDouble(json['balance']) ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      updatedAt: json['updated_at'] as String? ?? '',
      updatedAtLabel: formatDate(json['updated_at'] as String?),
    );
  }

  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String formatDate(String? value) {
    if (value == null || value.isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return DateFormat('yyyy/MM/dd - hh:mm a').format(parsed.toLocal());
  }
}

