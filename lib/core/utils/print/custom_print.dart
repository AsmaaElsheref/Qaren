import 'package:flutter/foundation.dart';
import '../colorConsol/color_consol.dart';

void customPrint(dynamic text, {bool isError = false, bool isException = false}) {
  if (kDebugMode) {
    if (isError) {
      // ignore: avoid_print
      print(error('$text'));
    } else if (isException) {
      // ignore: avoid_print
      print(exception('$text'));
    } else {
      // ignore: avoid_print
      print(show('$text'));
    }
  }
}


