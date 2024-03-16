import 'package:flutter/material.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StepProgressIndicator extends StatelessWidget {
  final String? stepTxt;
  final double? percentage;

  StepProgressIndicator({Key? key, this.stepTxt, this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 26.0,
      animation: true,
      animationDuration: 1200,
      lineWidth: 4.0,
      percent: percentage.validate(),
      center: Text(stepTxt.validate(), style: boldTextStyle()),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: progressIndicatorColor.withOpacity(0.4),
      progressColor: progressIndicatorColor,
    );
  }
}
