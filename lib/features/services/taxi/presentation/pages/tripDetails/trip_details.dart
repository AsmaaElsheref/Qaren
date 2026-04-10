import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_constants.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/localStorage/cache_helper.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/ui/widgets/custom_app_bar.dart';
import '../../../domain/entities/book_car_rental_params.dart';
import '../../providers/bookingProvider/booking_provider.dart';
import '../../providers/bookingProvider/booking_state.dart';
import '../../providers/offerDetailsProvider/offer_details_provider.dart';
import '../../providers/offerDetailsProvider/offer_details_state.dart';
import '../../widgets/tripDetails/trip_container.dart';
import '../bookingSuccess/booking_success_page.dart';

class TripDetails extends ConsumerStatefulWidget {
  const TripDetails({
    super.key,
    required this.serviceName,
    required this.offerId,
  });

  final String serviceName;
  final String offerId;

  @override
  ConsumerState<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends ConsumerState<TripDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(offerDetailsProvider.notifier).fetch(widget.offerId);
      ref.read(bookingProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(offerDetailsStatusProvider);

    // ── Booking state listener ─────────────────────────────────────────────
    ref.listen<BookingState>(bookingProvider, (previous, next) {
      if (next.status == BookingStatus.success &&
          previous?.status != BookingStatus.success) {
        final result = next.result;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BookingSuccessPage(
              bookingReference: result?.bookingReference ?? '',
              message: result?.providerResponse.message ?? 'تم الحجز بنجاح',
            ),
          ),
          (_) => false,
        );
      }
      if (next.status == BookingStatus.failure &&
          previous?.status != BookingStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'فشل الحجز. حاول مرة أخرى.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppBar(title: 'تفاصيل الرحلة', isBack: true, icon: Icons.share),
      ),
      body: _buildBody(status),
    );
  }

  Widget _buildBody(OfferDetailsStatus status) {
    switch (status) {
      case OfferDetailsStatus.initial:
      case OfferDetailsStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );

      case OfferDetailsStatus.failure:
        final errorMessage = ref.watch(offerDetailsProvider).errorMessage;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textHint),
              const SizedBox(height: AppDimensions.paddingM),
              Text(
                errorMessage ?? 'حدث خطأ. حاول مرة أخرى.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingL),
              AppButton(
                label: 'إعادة المحاولة',
                icon: Icons.refresh,
                onTap: () => ref
                    .read(offerDetailsProvider.notifier)
                    .fetch(widget.offerId),
              ),
            ],
          ),
        );

      case OfferDetailsStatus.success:
        final bookingStatus = ref.watch(bookingStatusProvider);
        final details = ref.watch(offerDetailsProvider).details;
        final isBooking = bookingStatus == BookingStatus.loading;

        // Read cached user data — set once at login/signup.
        final cachedName = CacheHelper.getData(key: AppConstants.userName) as String? ?? '';
        final cachedPhone = CacheHelper.getData(key: AppConstants.userPhone) as String? ?? '';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingM),
                TripContainer(serviceName: widget.serviceName),
                const SizedBox(height: AppDimensions.paddingL),
                // AppButton(
                //   color: AppColors.black,
                //   radius: 15,
                //   removeShadow: true,
                //   icon: Icons.file_download_outlined,
                //   label: 'حفظ الفاتورة',
                //   onTap: () {},
                // ),
                AppButton(
                  color: AppColors.black,
                  radius: 15,
                  removeShadow: true,
                  icon: Icons.file_download_outlined,
                  label: 'احجز الآن',
                  isLoading: isBooking,
                  onTap: isBooking
                      ? null
                      : () {
                          ref.read(bookingProvider.notifier).book(
                                BookCarRentalParams(
                                  offerId: widget.offerId,
                                  name: cachedName,
                                  phone: cachedPhone,
                                  providerSlug:
                                      details?.provider.slug ?? '',
                                ),
                              );
                        },
                ),
              ],
            ),
          ),
        );
    }
  }
}
