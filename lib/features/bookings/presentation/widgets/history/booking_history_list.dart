import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';

import '../../pages/booking_details_page.dart';
import '../../providers/booking_history_provider.dart';
import 'booking_card.dart';
import 'booking_empty_state.dart';
import 'booking_error_state.dart';
import 'booking_loading_skeleton.dart';

class BookingHistoryList extends ConsumerWidget {
  const BookingHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitialLoading = ref.watch(
      bookingHistoryProvider.select((state) => state.isInitialLoading),
    );
    final errorMessage = ref.watch(
      bookingHistoryProvider.select((state) => state.errorMessage),
    );
    final bookings = ref.watch(
      bookingHistoryProvider.select((state) => state.bookings),
    );
    final isLoadingMore = ref.watch(
      bookingHistoryProvider.select((state) => state.isLoadingMore),
    );

    if (isInitialLoading) return const BookingLoadingSkeleton();

    if (errorMessage != null && bookings.isEmpty) {
      return BookingErrorState(
        message: errorMessage,
        onRetry: () => ref.read(bookingHistoryProvider.notifier).loadInitial(),
      );
    }

    if (bookings.isEmpty) return const BookingEmptyState();

    return RefreshIndicator(
      onRefresh: () => ref.read(bookingHistoryProvider.notifier).refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 220) {
            ref.read(bookingHistoryProvider.notifier).loadMore();
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          itemBuilder: (context, index) {
            if (index == bookings.length) {
              return const Padding(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final booking = bookings[index];
            return BookingCard(
              booking: booking,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailsPage(bookingId: booking.id),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.paddingM),
          itemCount: bookings.length + (isLoadingMore ? 1 : 0),
        ),
      ),
    );
  }
}

