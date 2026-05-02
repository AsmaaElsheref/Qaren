import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_logout_item.dart';
import 'profile_menu_item_row.dart';

class ProfileGeneralMenuCard extends StatelessWidget {
  final VoidCallback onWallet;
  final VoidCallback onFavorites;
  final VoidCallback onNotifications;
  final VoidCallback onPrivacy;
  final VoidCallback onLogout;

  const ProfileGeneralMenuCard({
    super.key,
    required this.onWallet,
    required this.onFavorites,
    required this.onNotifications,
    required this.onPrivacy,
    required this.onLogout,
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
          ProfileMenuItemRow(
            label: 'المحفظة',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF27AAE1),
            iconBackground: const Color(0xFFE8F4FD),
            onTap: onWallet,
          ),
          ProfileMenuItemRow(
            label: 'المفضلة',
            icon: Icons.favorite_outline_rounded,
            iconColor: const Color(0xFFE91E8C),
            iconBackground: const Color(0xFFFDE8F5),
            onTap: onFavorites,
          ),
          ProfileMenuItemRow(
            label: 'الإشعارات',
            icon: Icons.notifications_outlined,
            iconColor: const Color(0xFFF4A730),
            iconBackground: const Color(0xFFFFF3E0),
            onTap: onNotifications,
          ),
          ProfileMenuItemRow(
            label: 'الخصوصية',
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF8DC73F),
            iconBackground: const Color(0xFFEFF8E2),
            onTap: onPrivacy,
          ),
          ProfileLogoutItem(onTap: onLogout),
        ],
      ),
    );
  }
}

