import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_constants.dart';
import 'package:qaren/core/localStorage/cache_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/personal_profile_provider.dart';
import 'profile_account_info_item.dart';

class ProfileAccountCard extends StatelessWidget {
  const ProfileAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final email = CacheHelper.getData(key: AppConstants.userEmail);
    final phone = CacheHelper.getData(key: AppConstants.userPhone);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAccountInfoItem(
            label: 'EMAIL',
            value: email,
            icon: Icons.mail_outline_rounded,
            iconColor: const Color(0xFF27AAE1),
            iconBackground: const Color(0xFFE8F4FD),
          ),
          ProfileAccountInfoItem(
            label: 'PHONE',
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

