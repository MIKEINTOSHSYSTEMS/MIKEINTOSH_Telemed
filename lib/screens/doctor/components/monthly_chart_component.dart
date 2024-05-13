import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class MonthlyChartComponent extends StatefulWidget {
  final List<WeeklyAppointment>? weeklyAppointment;

  MonthlyChartComponent({this.weeklyAppointment});

  @override
  State<StatefulWidget> createState() => MonthlyChartComponentState();
}

class MonthlyChartComponentState extends State<MonthlyChartComponent> {
  final Duration animDuration = Duration(milliseconds: 250);

  int? touchedIndex;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 12 / 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          BarChart(
            mainBarData(),
            swapAnimationDuration: animDuration,
          ).paddingSymmetric(horizontal: 8).expand(),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 10,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : appSecondaryColor,
          width: width,
          borderRadius: BorderRadius.circular(2),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 80,
            color: appSecondaryColor.withOpacity(0.4),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(widget.weeklyAppointment!.length, (i) {
      return makeGroupData(
        i,
        widget.weeklyAppointment![i].y.validate().toDouble(),
        isTouched: i == touchedIndex,
        barColor: primaryColor,
      );
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      groupsSpace: 0,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: context.scaffoldBackgroundColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              late String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'W1';
                  break;
                case 1:
                  weekDay = 'W2';
                  break;
                case 2:
                  weekDay = 'W3';
                  break;
                case 3:
                  weekDay = 'W4';
                  break;
                case 4:
                  weekDay = 'W5';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.toY - 1).toString(), TextStyle(color: primaryColor));
            }),
      ),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(drawBelowEverything: false),
        rightTitles: AxisTitles(drawBelowEverything: false),
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 28,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles1,
            reservedSize: 38,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: false),
      barGroups: showingGroups(),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        return text = Text('W1', style: secondaryTextStyle(size: 12, color: secondaryTxtColor));
      case 1:
        return text = Text('W2', style: secondaryTextStyle(size: 12, color: secondaryTxtColor));
      case 2:
        return text = Text('W3', style: secondaryTextStyle(size: 12, color: secondaryTxtColor));
      case 3:
        return text = Text('W4', style: secondaryTextStyle(size: 12, color: secondaryTxtColor));
      case 4:
        return text = Text('W5', style: secondaryTextStyle(size: 12, color: secondaryTxtColor));
      default:
        text = Text('', style: boldTextStyle(size: 14));
        break;
    }
    return text.withWidth(20);
  }

  Widget getTitles1(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case -1:
        return text = Text('M', style: boldTextStyle(size: 14));

      default:
        text = Text('${(value % 100).toInt()}', style: secondaryTextStyle(size: 12));
        break;
    }
    return Padding(padding: EdgeInsets.only(top: 16), child: text);
  }
}
