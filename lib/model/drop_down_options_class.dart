import 'package:intl/intl.dart';

import '../main.dart';

class StatsFilters {
  static String weekly = 'weekly';
  static String monthly = 'monthly';
  static String yearly = 'yearly';
}

class DropDownOptionsClass {
  final String value;
  String title;
  String? startDate;
  String? endDate;
  bool isCurrentWeek;

  DropDownOptionsClass({required this.value, required this.title, this.startDate, this.endDate, this.isCurrentWeek = false});
}

List<DropDownOptionsClass> statsOptions = [
  DropDownOptionsClass(title: locale.lblWeekly, value: StatsFilters.weekly),
  DropDownOptionsClass(title: locale.lblMonthly, value: StatsFilters.monthly),
  DropDownOptionsClass(title: locale.lblYearly, value: StatsFilters.yearly),
];

List<DropDownOptionsClass> getMonthsList = [
  DropDownOptionsClass(title: locale.lblJanuary, value: "1"),
  DropDownOptionsClass(title: locale.lblFebruary, value: "2"),
  DropDownOptionsClass(title: locale.lblMarch, value: '3'),
  DropDownOptionsClass(title: locale.lblApril, value: '4'),
  DropDownOptionsClass(title: locale.lblMay, value: '5'),
  DropDownOptionsClass(title: locale.lblJune, value: '6'),
  DropDownOptionsClass(title: locale.lblJuly, value: '7'),
  DropDownOptionsClass(title: locale.lblAugust, value: '8'),
  DropDownOptionsClass(title: locale.lblSeptember, value: '9'),
  DropDownOptionsClass(title: locale.lblOctober, value: '10'),
  DropDownOptionsClass(title: locale.lblNovember, value: '11'),
  DropDownOptionsClass(title: locale.lblDecember, value: '12'),
];

List<DropDownOptionsClass> getYearsList() {
  List<DropDownOptionsClass> list = [];

  var date = new DateTime.now().year;

  List.generate(3, (index) {
    list.add(DropDownOptionsClass(value: '${date - index}', title: '${date - index}'));
  });

  return list;
}

List<DropDownOptionsClass> getWeeksList() {
  List<DropDownOptionsClass> list = [];

  DateTime date = DateTime.utc(2023, 01, 01);
  DateTime endDate = DateTime.utc(2023, 12, 30);
  List<DateTime> week = [];

  int count = 1;

  while (date.difference(endDate).inDays <= 0) {
    if (date.weekday == 1 && week.length > 0) {
      list.add(DropDownOptionsClass(
        value: count.toString(),
        title: 'week-$count (${DateFormat('yyyy-MM-dd').format(date)}',
        startDate: DateFormat('yyyy-MM-dd').format(date),
      ));
    }

    if (date.weekday == 7 && week.length > 0 && list.isNotEmpty) {
      list[count - 1].endDate = DateFormat('yyyy-MM-dd').format(date);
      list[count - 1].title = '${list[count - 1].startDate} to ${DateFormat('yyyy-MM-dd').format(date)}';

      count++;
    }

    if (date == endDate) {
      list[count - 1].endDate = DateFormat('yyyy-MM-dd').format(date);
      list[count - 1].title = '${list[count - 1].startDate} to ${DateFormat('yyyy-MM-dd').format(date)}';
      count++;
    }

    if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      list[count - 1].isCurrentWeek = true;
    }

    week.add(date);
    date = date.add(const Duration(days: 1));
  }

  return list;
}
