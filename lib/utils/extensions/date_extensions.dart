import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

extension DateExt on DateTime {
  String getFormattedDate(String format) {
    return DateFormat(format).format(this);
  }

  String getDateInString({String? format}) {
    if (this.isToday)
      return locale.lblToday;
    else if (this.isTomorrow)
      return locale.lblTomorrow;
    else if (this.isYesterday)
      return locale.lblYesterday;
    else
      return this.getFormattedDate(format.validate());
  }
}
