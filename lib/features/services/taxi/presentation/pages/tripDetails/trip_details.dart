import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_constants.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/localStorage/cache_helper.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/ui/widgets/custom_app_bar.dart';
import 'package:qaren/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:qaren/features/auth/presentation/guards/guest_access_guard.dart';
import '../../../domain/entities/book_car_rental_params.dart';
import '../../providers/bookingProvider/booking_provider.dart';
import '../../providers/bookingProvider/booking_state.dart';
import '../../providers/offerDetailsProvider/offer_details_provider.dart';
import '../../providers/offerDetailsProvider/offer_details_state.dart';
import '../../providers/taxi_notifier.dart';
import '../../providers/taxi_reset_controller.dart';
import '../../widgets/tripDetails/trip_container.dart';
import '../bookingSuccess/booking_success_page.dart';

class TripDetails extends ConsumerStatefulWidget {
  const TripDetails({
    super.key,
    required this.serviceName,
    required this.carId,
  });

  final String serviceName;
  final String carId;

  @override
  ConsumerState<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends ConsumerState<TripDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(offerDetailsProvider.notifier).fetch(widget.carId);
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
        ref.read(bookingProvider.notifier).reset();
        // Reset all taxi + AI assistant state after a successful booking.
        ref.read(taxiResetControllerProvider).resetAfterSuccessfulBooking();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BookingSuccessPage(
              bookingReference: result?.bookingReference ?? '',
              message:
                  result?.providerResponse.message ??
                  'taxi.booking.successMessage'.tr(),
            ),
          ),
          (_) => false,
        );
      }
      if (next.status == BookingStatus.failure &&
          previous?.status != BookingStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'taxi.booking.failed'.tr()),
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
        child: CustomAppBar(title: 'taxi.tripDetails.title'.tr(), isBack: true),
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
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.textHint,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Text(
                errorMessage ?? 'taxi.errors.generic'.tr(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingL),
              AppButton(
                label: 'common.retry'.tr(),
                icon: Icons.refresh,
                onTap: () =>
                    ref.read(offerDetailsProvider.notifier).fetch(widget.carId),
              ),
            ],
          ),
        );

      case OfferDetailsStatus.success:
        final bookingStatus = ref.watch(bookingStatusProvider);
        final taxiState = ref.watch(taxiProvider);
        final isBooking = bookingStatus == BookingStatus.loading;
        final pickup = taxiState.pickupLatLng;
        final dropoff = taxiState.destinationLatLng;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingM),
                TripContainer(serviceName: widget.serviceName),
                const SizedBox(height: AppDimensions.paddingL),
                AppButton(
                  radius: 15,
                  removeShadow: true,
                  icon: Icons.file_download_outlined,
                  label: 'taxi.compare.bookNow'.tr(),
                  isLoading: isBooking,
                  onTap: isBooking
                      ? null
                      : () async {
                          if (!await GuestAccessGuard.ensureAuthenticated(
                            context: context,
                            ref: ref,
                          )) {
                            return;
                          }
                          if (!mounted) return;

                          if (pickup == null || dropoff == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'taxi.errors.selectPickupDestination'.tr(),
                                ),
                              ),
                            );
                            return;
                          }

                          final cachedUserId = CacheHelper.getData(
                            key: AppConstants.userId,
                          );
                          final userId = cachedUserId is int
                              ? cachedUserId
                              : int.tryParse(cachedUserId?.toString() ?? '') ??
                                    (await ref.read(
                                      userProfileProvider.future,
                                    )).id;

                          if (!mounted) return;
                          ref
                              .read(bookingProvider.notifier)
                              .book(
                                BookCarRentalParams(
                                  userId: userId.toString(),
                                  pickupLat: pickup.latitude,
                                  pickupLng: pickup.longitude,
                                  dropoffLat: dropoff.latitude,
                                  dropoffLng: dropoff.longitude,
                                  carId: widget.carId,
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
