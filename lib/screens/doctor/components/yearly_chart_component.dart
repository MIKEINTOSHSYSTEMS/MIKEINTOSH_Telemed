import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class YearlyChartComponent extends StatefulWidget {
  final List<WeeklyAppointment>? weeklyAppointment;

  YearlyChartComponent({this.weeklyAppointment});

  @override
  State<StatefulWidget> createState() => YearlyChartComponentState();
}

class YearlyChartComponentState extends State<YearlyChartComponent> {
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
            toY: 200,
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
                  weekDay = locale.lblJan;
                  break;
                case 1:
                  weekDay = locale.lblFeb;
                  break;
                case 2:
                  weekDay = locale.lblMar;
                  break;
                case 3:
                  weekDay = locale.lblApr;
                  break;
                case 4:
                  weekDay = locale.lblMay;
                  break;
                case 5:
                  weekDay = locale.lblJun;
                  break;
                case 6:
                  weekDay = locale.lblJul;
                  break;
                case 7:
                  weekDay = locale.lblAug;
                  break;
                case 8:
                  weekDay = locale.lblSep;
                  break;
                case 9:
                  weekDay = locale.lblOct;
                  break;
                case 10:
                  weekDay = locale.lblNov;
                  break;
                case 11:
                  weekDay = locale.lblDec;
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
            reservedSize: 20,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles1,
            reservedSize: 16,
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
        return text = Text(locale.lblJan, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 1:
        return text = Text(locale.lblFeb, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 2:
        return text = Text(locale.lblMar, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 3:
        return text = Text(locale.lblApr, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 4:
        return text = Text(locale.lblMay, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 5:
        return text = Text(locale.lblJun, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 6:
        return text = Text(locale.lblJul, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 7:
        return text = Text(locale.lblAug, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 8:
        return text = Text(locale.lblSep, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 9:
        return text = Text(locale.lblOct, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 10:
        return text = Text(locale.lblNov, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));
      case 11:
        return text = Text(locale.lblDec, style: secondaryTextStyle(size: 10, color: secondaryTxtColor));

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
        text = Text('${(value % 1000).toInt()}', style: secondaryTextStyle(size: 8));
        break;
    }
    return Padding(padding: EdgeInsets.only(top: 16), child: text);
  }
}
