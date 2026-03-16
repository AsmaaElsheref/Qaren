import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/ui/widgets/custom_app_bar.dart';
import '../../providers/searchProvider/search_loading_provider.dart';
import 'search_loading_dialog.dart';

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
            Image.asset(AppImages.searching),
            AppText("4 كابتن متاح",style: TextStyle(color: AppColors.textSecondary,fontSize: 17),),
            Spacer(),
            AppButton(label: "عرض النتائج", onTap: () async {
              await SearchLoadingDialog.show(context);

            }),
            SizedBox(height: context.screenHeight*0.1,)
          ],
        ),
      ),
    );
  }
}
