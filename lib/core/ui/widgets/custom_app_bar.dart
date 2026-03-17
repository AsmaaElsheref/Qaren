import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/icon_container.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import 'AppText.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key, this.title, this.isBack,this.icon,});

  final String? title;
  final bool? isBack;
  final IconData? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(isBack==true)
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios),
                ),
              title!=null?
              AppText(title!,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.black),):
              SizedBox(),
              if(icon!=null)
              IconContainer(icon: Icon(icon),onTap: (){},)
            ],
          ),
        ),
      ),
    );
  }
}
