import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/login_params.dart';

class UserTypeSelector extends StatelessWidget {
  final UserTypeTab selected;
  final ValueChanged<UserTypeTab> onChanged;

  const UserTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.tabHeight,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: UserTypeTab.values.reversed.map((tab) {
          final isSelected = tab == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(7),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _iconFor(tab),
                      size: 16,
                      color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: AppDimensions.fontS,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _iconFor(UserTypeTab tab) {
    switch (tab) {
      case UserTypeTab.user:
        return Icons.person_outline;
      case UserTypeTab.partner:
        return Icons.store_outlined;
      case UserTypeTab.admin:
        return Icons.shield_outlined;
    }
  }
}

