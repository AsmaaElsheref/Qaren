import 'package:flutter/cupertino.dart';

class Gap {
  Gap._();

  static const SizedBox gapH5 = SizedBox(height: 5);
  static const SizedBox gapH10 = SizedBox(height: 10);
  static const SizedBox gapH15 = SizedBox(height: 15);
  static const SizedBox gapH20 = SizedBox(height: 20);
  static const SizedBox gapH25 = SizedBox(height: 25);
  static const SizedBox gapH30 = SizedBox(height: 30);

  static const SizedBox gapW5 = SizedBox(width: 5);
  static const SizedBox gapW10 = SizedBox(width: 10);
  static const SizedBox gapW15 = SizedBox(width: 15);
  static const SizedBox gapW20 = SizedBox(width: 20);
  static const SizedBox gapW25 = SizedBox(width: 25);
  static const SizedBox gapW30 = SizedBox(width: 30);

  static SizedBox gapHW({h,w})=> SizedBox(height: h, width: w);

}