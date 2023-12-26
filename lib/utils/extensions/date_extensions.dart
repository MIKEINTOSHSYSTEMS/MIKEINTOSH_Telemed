import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String getFormattedDate(String format) {
    return DateFormat(format).format(this);
  }
}
