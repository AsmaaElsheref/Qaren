import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../widgets/success/success_actions.dart';
import '../../widgets/success/success_header.dart';
import '../../widgets/success/success_info_card.dart';
import '../../widgets/success/success_items_list.dart';
/// Booking-success screen.
///
/// Purely compositional - sub-widgets read the booking response from
/// [foodBookingResultProvider] independently, so this page never rebuilds
/// itself on state change.
class SuccessPage extends ConsumerWidget {
  const SuccessPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: const [
                SuccessHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SuccessInfoCard(),
                        SizedBox(height: AppDimensions.paddingM),
                        SuccessItemsList(),
                        SizedBox(height: AppDimensions.paddingM),
                      ],
                    ),
                  ),
                ),
                SuccessActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
