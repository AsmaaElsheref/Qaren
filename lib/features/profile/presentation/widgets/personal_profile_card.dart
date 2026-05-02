import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';
import '../providers/personal_profile_provider.dart';
import 'profile_avatar_with_camera.dart';
import 'profile_stats_row.dart';

class PersonalProfileCard extends ConsumerWidget {
  final VoidCallback onCameraTap;

  const PersonalProfileCard({super.key, required this.onCameraTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Granular selectors — each rebuilds only its section
    final avatarUrl = ref.watch(profileAvatarUrlProvider);
    final identity = ref.watch(profileIdentityProvider);
    final stats = ref.watch(profileStatsProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Mint strip with avatar overlapping ────────────────────────
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // Mint background strip
              Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7F2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              ),
              // Avatar centred, half overlapping the strip
              Positioned(
                bottom: -45,
                child: ProfileAvatarWithCamera(
                  avatarUrl: avatarUrl,
                  onCameraTap: onCameraTap,
                ),
              ),
            ],
          ),

          // Space for the overlapping part of the avatar
          const SizedBox(height: 52),

          // ── Name & location ──────────────────────────────────────────
          AppText(
            identity.name,
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                identity.location,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),

          // ── Stats row ────────────────────────────────────────────────
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProfileStatsRow(
              ordersCount: stats.orders,
              tripsCount: stats.trips,
              savingsAmount: stats.savings,
              savingsCurrency: stats.currency,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

