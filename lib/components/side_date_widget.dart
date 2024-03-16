import 'package:flutter/material.dart';
import 'package:momona_healthcare/utils/extensions/int_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class SideDateWidget extends StatelessWidget {
  final DateTime tempDate;

  SideDateWidget({required this.tempDate, Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: tempDate.day.toString(), style: boldTextStyle(size: 22)),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(2, -10),
                    child: Text(tempDate.day.validate().toSuffix(), textScaleFactor: 0.7, style: boldTextStyle(size: 14)),
                  ),
                )
              ],
            ),
          ),
          Text(tempDate.month.getMonthName().validate(), textAlign: TextAlign.center, style: secondaryTextStyle()),
        ],
      ),
    );
  }
}
