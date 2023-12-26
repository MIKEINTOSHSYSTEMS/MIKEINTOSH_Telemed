import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

extension StExt on String {
  String getFormattedDate(String format) {
    return DateFormat(format).format(DateTime.parse(this));
  }

  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (appStore.isDarkModeOn ? Colors.white : appSecondaryColor),
      errorBuilder: (context, error, stackTrace) {
        return PlaceHolderWidget();
      },
    );
  }

  int? getStatus() {
    int? id;
    if (this == BookedStatus) {
      return id = 1;
    } else if (this == CheckOutStatus) {
      return id = 3;
    } else if (this == CheckInStatus) {
      return id = 4;
    } else if (this == CancelledStatus) {
      return id = 0;
    }
    return id;
  }
}
