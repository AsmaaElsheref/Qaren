import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_images.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class QarenLogo extends StatelessWidget {
  const QarenLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Logo mark ──────────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadiusGeometry.circular(10),
              boxShadow: [
                BoxShadow(
                    color: AppColors.textHint,
                    spreadRadius: 1,
                    blurRadius: 7,
                )
              ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: Image.asset(
              AppImages.qarenLogo,
              width: context.screenWidth*0.35,
              height: context.screenHeight*0.15,
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}
