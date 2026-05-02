import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';

class SearchMapBar extends StatelessWidget {
  final TextEditingController searchController;
  final String googleApiKey;
  final void Function(String address) searchAddress;
  final void Function(Prediction prediction)? onPlaceSelected;

  const SearchMapBar({
    super.key,
    required this.searchController,
    required this.googleApiKey,
    required this.searchAddress,
    this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: searchController,
          googleAPIKey: googleApiKey,
          inputDecoration: const InputDecoration(
            hintText: 'ابحث عن موقع على الخريطة...',
            disabledBorder: InputBorder.none,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusL)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusL)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusL)),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          boxDecoration: BoxDecoration(
            border: Border.all(color: AppColors.surface),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          debounceTime: 500,
          isLatLngRequired: true,
          placeType: PlaceType.geocode,
          keyboardType: TextInputType.text,
          isCrossBtnShown: true,
          containerHorizontalPadding: 0,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            onPlaceSelected?.call(prediction);
          },
          itemClick: (Prediction prediction) {
            final description = prediction.description ?? '';
            searchController.text = description;
            searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: description.length),
            );
            searchAddress(description);
            onPlaceSelected?.call(prediction);
          },
          itemBuilder: (context, index, Prediction prediction) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                color: AppColors.surface,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        prediction.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          seperatedBuilder: const Divider(
            height: 1,
            thickness: 0.6,
            color: AppColors.border,
          ),
        ),
      ),
    );
  }
}