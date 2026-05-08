import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';

import '../widgets/history/active_filters_row.dart';
import '../widgets/history/booking_history_header.dart';
import '../widgets/history/booking_history_list.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BookingHistoryHeader(),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: AppDimensions.paddingS),
              ActiveFiltersRow(),
              Expanded(child: BookingHistoryList()),
            ],
          ),
        ),
      ),
    );
  }
}
