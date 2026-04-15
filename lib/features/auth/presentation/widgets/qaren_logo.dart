import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_images.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class QarenLogo extends StatelessWidget {
  const QarenLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.qarenLogo,
      width: context.screenWidth*0.35,
      height: context.screenHeight*0.15,
      fit: BoxFit.cover,
    );
  }
}