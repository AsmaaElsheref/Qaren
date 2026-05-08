import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/features/coming_soon/presentation/widgets/coming_soon_action_button.dart';
import 'package:qaren/features/coming_soon/presentation/widgets/coming_soon_description.dart';
import 'package:qaren/features/coming_soon/presentation/widgets/coming_soon_icon.dart';
import 'package:qaren/features/coming_soon/presentation/widgets/coming_soon_title.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ComingSoonIcon(),
              SizedBox(height: AppDimensions.paddingXL),
              ComingSoonTitle(),
              SizedBox(height: AppDimensions.paddingM),
              ComingSoonDescription(),
            ],
          ),
        ),
      ),
    );
  }
}
