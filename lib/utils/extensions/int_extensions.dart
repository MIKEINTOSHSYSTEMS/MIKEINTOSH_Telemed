import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

extension intExt on int? {
  String getMonthName() {
    if (this == 1) {
      return locale.lblJan;
    } else if (this == 2) {
      return locale.lblFeb;
    } else if (this == 3) {
      return locale.lblMar;
    } else if (this == 4) {
      return locale.lblApr;
    } else if (this == 5) {
      return locale.lblMay;
    } else if (this == 6) {
      return locale.lblJun;
    } else if (this == 7) {
      return locale.lblJul;
    } else if (this == 8) {
      return locale.lblAug;
    } else if (this == 9) {
      return locale.lblSep;
    } else if (this == 10) {
      return locale.lblOct;
    } else if (this == 11) {
      return locale.lblNov;
    } else if (this == 12) {
      return locale.lblDec;
    }
    return '';
  }

  String getWeekDay() {
    if (this == 1) {
      return "Mon";
    } else if (this == 2) {
      return "Tue";
    } else if (this == 3) {
      return "Wed";
    } else if (this == 4) {
      return "Thu";
    } else if (this == 5) {
      return "Fri";
    } else if (this == 6) {
      return "Sat";
    } else if (this == 7) {
      return "Sun";
    }
    return '';
  }

  String getFullWeekDay() {
    if (this == 1) {
      return locale.lblMonday;
    } else if (this == 2) {
      return locale.lblTuesday;
    } else if (this == 3) {
      return locale.lblWednesday;
    } else if (this == 4) {
      return locale.lblThursday;
    } else if (this == 5) {
      return locale.lblFriday;
    } else if (this == 6) {
      return locale.lblSaturday;
    } else if (this == 7) {
      return locale.lblSunday;
    }
    return 'weekName';
  }

  String? getStatus() {
    String? id;
    if (this == 1) {
      return id = BookedStatus;
    } else if (this == 3) {
      return id = CheckOutStatus;
    } else if (this == 4) {
      return id = CheckInStatus;
    } else if (this == 0) {
      return id = CancelledStatus;
    }
    return id;
  }

  String toSuffix() {
    if (!(this.validate() >= 1 && this.validate() <= 31)) {
      throw Exception(locale.lblInvalidDayOfMonth);
    }

    if (this.validate() >= 11 && this.validate() <= 13) {
      return 'th';
    }

    switch (this.validate() % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String getFormattedCurrency({String? currencyName, int? decimalPoint}) {
    return NumberFormat.currency(
      name: currencyName ?? 'USD',
      symbol: appStore.currency,
      decimalDigits: decimalPoint ?? 0,
    ).format(this);
  }
}
