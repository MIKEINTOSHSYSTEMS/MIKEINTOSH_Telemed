import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

extension intExt on int? {
  String getMonthName() {
    if (this == 1) {
      return 'Jan';
    } else if (this == 2) {
      return 'Feb';
    } else if (this == 3) {
      return 'Mar';
    } else if (this == 4) {
      return 'Apr';
    } else if (this == 5) {
      return 'May';
    } else if (this == 6) {
      return 'Jun';
    } else if (this == 7) {
      return 'Jul';
    } else if (this == 8) {
      return 'Aug';
    } else if (this == 9) {
      return 'Sept';
    } else if (this == 10) {
      return 'Oct';
    } else if (this == 11) {
      return 'Nov';
    } else if (this == 12) {
      return 'Dec';
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
      return "Monday";
    } else if (this == 2) {
      return "Tuesday";
    } else if (this == 3) {
      return "Wednesday";
    } else if (this == 4) {
      return "Thursday";
    } else if (this == 5) {
      return "Friday";
    } else if (this == 6) {
      return "Saturday";
    } else if (this == 7) {
      return "Sunday";
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

  String getFormattedPrice() {
    return '${appStore.currency}$this';
  }

  String toSuffix() {
    if (!(this.validate() >= 1 && this.validate() <= 31)) {
      throw Exception('Invalid day of month');
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
}
