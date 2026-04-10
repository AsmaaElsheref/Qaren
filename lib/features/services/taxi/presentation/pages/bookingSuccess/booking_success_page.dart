import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../home/presentation/pages/home_page.dart';

/// Shown after a successful booking — displays confirmation info
/// and a CTA to navigate back to the home screen.
class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({
    super.key,
    required this.bookingReference,
    required this.message,
  });

  final String bookingReference;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ── Success icon ───────────────────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 56,
                  color: AppColors.white,
                ),
              ),

              const SizedBox(height: AppDimensions.paddingL),

              // ── Title ──────────────────────────────────────────────────
              AppText(
                'تم الحجز بنجاح!',
                style: const TextStyle(
                  fontSize: AppDimensions.fontXXL,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.paddingM),

              // ── Message from API ───────────────────────────────────────
              AppText(
                message,
                secondary: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppDimensions.fontM,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: AppDimensions.paddingL),

              // ── Booking reference card ─────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    AppText(
                      'رقم الحجز',
                      secondary: true,
                      style: const TextStyle(fontSize: AppDimensions.fontS),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    AppText(
                      bookingReference,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Navigate home CTA ──────────────────────────────────────
              AppButton(
                label: 'العودة للرئيسية',
                icon: Icons.home_rounded,
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (_) => false,
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXL),
            ],
          ),
        ),
      ),
    );
  }
}

