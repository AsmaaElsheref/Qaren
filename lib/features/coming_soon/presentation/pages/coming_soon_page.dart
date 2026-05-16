import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/constants/gap.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/ui/widgets/icon_container.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import 'package:qaren/features/coming_soon/presentation/widgets/coming_soon_action_button.dart';
import 'package:qaren/features/coming_soon/presentation/widgets/coming_soon_description.dart';
import 'package:qaren/features/coming_soon/presentation/widgets/coming_soon_icon.dart';
import 'package:qaren/features/coming_soon/presentation/widgets/coming_soon_title.dart';
import 'package:qaren/features/home/presentation/widgets/home_app_bar.dart';
import 'package:qaren/features/notifications/presentation/widgets/notifications_app_bar.dart';
/// Generic placeholder page for tabs/routes that are not yet implemented.
/// Fully reusable — just push this page from any unfinished route.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ComingSoonIcon(),
                const SizedBox(height: AppDimensions.paddingXL),
                const ComingSoonTitle(),
                SizedBox(height: context.screenHeight*0.2,),
                AppButton(label: "الرجوع إلى الرئيسية", onTap: () => Navigator.pop(context),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
