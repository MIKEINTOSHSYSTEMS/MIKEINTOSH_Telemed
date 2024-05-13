import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

extension StExt on String {
  String getFormattedDate(String format) {
    return DateFormat(format).format(DateTime.parse(this));
  }

  String getFormattedTime() {
    return DateFormat(TIME_WITH_SECONDS).parse(this.validate()).getFormattedDate(FORMAT_12_HOUR);
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
    } else if (this == PendingStatus) {
      return id = 2;
    } else if (this == CheckOutStatus) {
      return id = 3;
    } else if (this == CheckInStatus) {
      return id = 4;
    } else if (this == CancelledStatus) {
      return id = 0;
    }
    return id;
  }

  bool getBoolInt() {
    if (this == "1") {
      return true;
    }
    return false;
  }

  String getApostropheString({int count = 0, bool apostrophe = true}) {
    if (this.length > 1) {
      return apostrophe ? "$this's" : '${this}s';
    }

    return this;
  }

  Widget iconImageColored({double? size, Color? color, BoxFit? fit, double? height, double? width, bool isRoundedCorner = false}) {
    return Image.asset(
      this,
      height: size ?? height ?? 24,
      width: size ?? width ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return PlaceHolderWidget();
      },
    ).cornerRadiusWithClipRRect(isRoundedCorner ? 8 : 0);
  }

  String suffixText({required String value}) {
    return "$this$value";
  }

  String prefixText({required String value}) {
    return "$value$this";
  }

  String fileFormatImage() {
    if (this.isPdf) {
      return icPdf;
    } else if (this.isDoc) {
      return icDoc;
    } else if (this.isImage) {
      return icJpg;
    } else if (this.isPPT) {
      return icPpt;
    } else if (this.isTxt) {
      return icTxt;
    }
    return icTxt;
  }

  String capitalizeEachWord() {
    if (this.isEmpty) {
      return '';
    }

    final capitalizedWords = this.split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      final firstLetter = word[0].toUpperCase();
      final remainingLetters = word.substring(1).toLowerCase();
      return '$firstLetter$remainingLetters';
    });

    return capitalizedWords.join(' ');
  }

  String setCurrency({bool isPrefix = true}) {
    if (this.isEmpty) {
      return '';
    }
    if (isPrefix)
      return "${appStore.currency}$this";
    else
      return "$this${appStore.currency}";
  }
}
