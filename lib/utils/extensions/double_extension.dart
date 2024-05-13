import 'dart:ui';

import 'package:kivicare_flutter/utils/colors.dart';

extension doubleExt on num {
  Color getRatingBarColor() {
    if (this >= 1.0 && this < 2) {
      return ratingBarRedColor;
    } else if (this >= 3.0 && this < 4) {
      return ratingBarOrangeColor;
    } else if (this >= 4.0 || this < 5) {
      return ratingBarLightGreenColor;
    } else {
      return ratingBarRedColor;
    }
  }
}
