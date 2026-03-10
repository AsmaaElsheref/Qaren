import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/ui/widgets/AppButton.dart';
import 'selected_location_address.dart';

class ConfirmLocationButton extends StatelessWidget {
  const ConfirmLocationButton({super.key, required this.isResolving, required this.isConfirming, required this.title, required this.confirm, required this.addressLabel});

  final bool isResolving;
  final bool isConfirming;
  final String title;
  final String addressLabel;
  final Function() confirm;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingM,
            0,
            AppDimensions.paddingM,
            AppDimensions.paddingM,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Address label card ────────────────────────────────
              SelectedLocationAddress(title: title,addressLabel: addressLabel,isResolving: isResolving,),
              const SizedBox(height: AppDimensions.paddingM),
              AppButton(
                label: 'تأكيد الموقع',
                icon: Icons.check_circle_outline_rounded,
                isLoading: isConfirming,
                onTap: isResolving ? null : confirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}