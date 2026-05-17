import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import '../providers/booking_details_provider.dart';
import '../widgets/details/booking_details_actions.dart';
import '../widgets/details/booking_details_header_card.dart';
import '../widgets/details/booking_details_pricing_card.dart';
import '../widgets/details/car_booking_details_section.dart';
import '../widgets/details/food_booking_details_section.dart';
import '../widgets/history/booking_error_state.dart';
import '../widgets/history/booking_loading_skeleton.dart';

class BookingDetailsPage extends ConsumerWidget {
  final int bookingId;

  const BookingDetailsPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingDetailsProvider(bookingId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppText('تفاصيل الطلب', style: AppTextStyles.title),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (state.isLoading) return const BookingLoadingSkeleton(itemCount: 4);

              if (state.errorMessage != null || state.details == null) {
                return BookingErrorState(
                  message: state.errorMessage,
                  onRetry: () => ref.read(bookingDetailsProvider(bookingId).notifier).load(),
                );
              }

              final booking = state.details!.booking;
              return ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                children: [
                  BookingDetailsHeaderCard(booking: booking),
                  const SizedBox(height: AppDimensions.paddingM),
                  BookingDetailsPricingCard(pricing: booking.pricing),
                  const SizedBox(height: AppDimensions.paddingM),
                  if (booking.foodOrder != null)
                    FoodBookingDetailsSection(foodOrder: booking.foodOrder!)
                  else if (booking.carRental != null)
                    CarBookingDetailsSection(carRental: booking.carRental!),
                  const SizedBox(height: AppDimensions.paddingL),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

