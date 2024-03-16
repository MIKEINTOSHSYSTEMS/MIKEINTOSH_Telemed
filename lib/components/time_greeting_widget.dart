import 'package:flutter/material.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:momona_healthcare/main.dart';

class TimeGreetingWidget extends StatelessWidget {
  final String? morningText;
  final String? afternoonText;
  final String? eveningText;
  final String? nightText;
  final String? userName;
  String? separator;
  final TextStyle? textStyle;
  final int? size;
  final Color? textColor;

  TimeGreetingWidget({this.userName, this.morningText, this.afternoonText, this.eveningText, this.textStyle, this.size, this.textColor, this.separator, this.nightText});

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final hour = currentTime.hour;

    if (userName != null || userName!.isNotEmpty) this.separator = '$separator $userName';
    String greeting;

    if (hour < 12) {
      greeting = (morningText ?? "${locale.lblGoodMorning}").suffixText(value: separator ?? "");
    } else if (hour < 17) {
      greeting = (afternoonText ?? '${locale.lblAfternoon}').suffixText(value: separator ?? "");
    } else if (hour < 21) {
      greeting = (eveningText ?? '${locale.lblGoodEvening}').suffixText(value: separator ?? "");
    } else {
      greeting = (nightText ?? '${locale.lblNight}').suffixText(value: separator ?? "");
    }

    return Text(greeting, style: textStyle ?? boldTextStyle(size: size ?? 18, color: textColor), maxLines: 1, overflow: TextOverflow.fade);
  }
}
