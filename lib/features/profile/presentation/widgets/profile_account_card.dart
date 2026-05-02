import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/personal_profile_provider.dart';
import 'profile_account_info_item.dart';

class ProfileAccountCard extends ConsumerWidget {
  const ProfileAccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when email or phone changes
    final contact = ref.watch(profileContactInfoProvider);

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
            value: contact.email,
            icon: Icons.mail_outline_rounded,
            iconColor: const Color(0xFF27AAE1),
            iconBackground: const Color(0xFFE8F4FD),
          ),
          ProfileAccountInfoItem(
            label: 'PHONE',
            value: contact.phone,
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

