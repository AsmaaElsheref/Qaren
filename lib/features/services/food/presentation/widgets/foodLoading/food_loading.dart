import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/ui/widgets/custom_app_bar.dart';
import '../../pages/food_result.dart';

class Searching extends ConsumerWidget {
  const Searching({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          bottom: false,
          child: CustomAppBar(isBack: true,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Column(
          children: [
            Image.asset(AppImages.foodLoading),
            Spacer(),
            AppButton(label: "عرض النتائج", onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FoodResult(),))),
            SizedBox(height: context.screenHeight*0.1,)
          ],
        ),
      ),
    );
  }
}