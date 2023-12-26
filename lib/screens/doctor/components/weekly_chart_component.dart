import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class WeeklyChartComponent extends StatefulWidget {
  List<WeeklyAppointment>? weeklyAppointment;

  WeeklyChartComponent({this.weeklyAppointment});

  @override
  State<StatefulWidget> createState() => WeeklyChartComponentState();
}

class WeeklyChartComponentState extends State<WeeklyChartComponent> {
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
            toY: 20,
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
                  weekDay = 'Mon';
                  break;
                case 1:
                  weekDay = 'Tue';
                  break;
                case 2:
                  weekDay = 'Wed';
                  break;
                case 3:
                  weekDay = 'Thu';
                  break;
                case 4:
                  weekDay = 'Fri';
                  break;
                case 5:
                  weekDay = 'Sat';
                  break;
                case 6:
                  weekDay = 'Sun';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.toY).toString(), TextStyle(color: primaryColor));
            }),
      ),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(drawBehindEverything: false),
        rightTitles: AxisTitles(drawBehindEverything: false),
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
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
        return text = Text('\n${locale.lblMon}', style: secondaryTextStyle(size: 12));
      case 1:
        return text = Text('\n${locale.lblTue}', style: secondaryTextStyle(size: 12));
      case 2:
        return text = Text('\n${locale.lblWed}', style: secondaryTextStyle(size: 12));
      case 3:
        return text = Text('\n${locale.lblThu}', style: secondaryTextStyle(size: 12));
      case 4:
        return text = Text('\n${locale.lblFri}', style: secondaryTextStyle(size: 12));
      case 5:
        return text = Text('\n${locale.lblSat}', style: secondaryTextStyle(size: 12));
      case 6:
        return text = Text('\n${locale.lblSun}', style: secondaryTextStyle(size: 12));
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
