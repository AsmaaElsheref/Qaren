import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import 'search_icon.dart';
import 'search_map_bar.dart';

class SearchMap extends StatelessWidget {
  const SearchMap({super.key, required this.searchController, required this.searchAddress});

  final TextEditingController searchController ;
  final Function(String) searchAddress ;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          child: Row(
            children: [
              SearchMapBar(searchController: searchController,searchAddress: searchAddress,),
              const SizedBox(width: AppDimensions.paddingS),
              SearchIcon(searchAddress: searchAddress,),
            ],
          ),
        ),
      ),
    );
  }
}
