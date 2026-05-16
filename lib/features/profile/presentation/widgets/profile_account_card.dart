import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_account_info_item.dart';

class ProfileAccountCard extends StatelessWidget {
  final String email;
  final String phone;

  const ProfileAccountCard({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAccountInfoItem(
            label: 'البريد الإلكتروني',
            value: email,
            icon: Icons.mail_outline_rounded,
            iconColor: const Color(0xFF27AAE1),
            iconBackground: const Color(0xFFE8F4FD),
          ),
          ProfileAccountInfoItem(
            label: 'رقم الهاتف',
            value: phone,
            icon: Icons.phone_outlined,
            iconColor: const Color(0xFF8DC73F),
            iconBackground: const Color(0xFFEFF8E2),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
