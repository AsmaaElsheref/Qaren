import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/ui/widgets/custom_app_bar.dart';
import '../../widgets/tripDetails/trip_container.dart';

class TripDetails extends StatelessWidget {
  const TripDetails({super.key, required this.serviceName});

  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(title: 'تفاصيل الرحلة',isBack: true,icon: Icons.share,)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.paddingM,),
              TripContainer(serviceName: serviceName,),
              SizedBox(height: AppDimensions.paddingL,),
              AppButton(
                color: AppColors.black,
                radius: 15,
                removeShadow: true,
                icon: Icons.file_download_outlined,
                label: 'حفظ الفاتورة',
                onTap: (){}
              )
            ],
          ),
        ),
      ),
    );
  }
}
