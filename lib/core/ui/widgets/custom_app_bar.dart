import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'AppText.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key, this.title, this.isBack});

  final String? title;
  final bool? isBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: isBack==true?0:20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isBack==true?
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios),
                ):
              title!=null?
              AppText(title!,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),):
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
