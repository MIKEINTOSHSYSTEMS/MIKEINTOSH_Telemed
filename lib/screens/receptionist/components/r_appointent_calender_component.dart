import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/network/appointment_repository.dart';
import 'package:momona_healthcare/screens/doctor/fragments/appointment_fragment.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/widgets/calender/date_utils.dart';
import 'package:momona_healthcare/utils/widgets/calender/flutter_clean_calendar.dart';
import 'package:nb_utils/nb_utils.dart';

class RAppointentCalenderComponent extends StatefulWidget {
  const RAppointentCalenderComponent({Key? key}) : super(key: key);

  @override
  _RAppointentCalenderComponentState createState() => _RAppointentCalenderComponentState();
}

class _RAppointentCalenderComponentState extends State<RAppointentCalenderComponent> {
  Map<DateTime, List> _events = {};

  Future<List<UpcomingAppointmentModel>>? future;

  List<UpcomingAppointmentModel> appointmentList = [];

  int page = 1;

  bool isLastPage = false;
  bool isRangeSelected = false;

  String startDate = DateTime(DateTime.now().year, DateTime.now().month, 1).getFormattedDate(SAVE_DATE_FORMAT);
  String endDate = DateTime(DateTime.now().year, DateTime.now().month, Utils.lastDayOfMonth(DateTime.now()).day).getFormattedDate(SAVE_DATE_FORMAT);

  DateTime selectedDate = DateTime.parse(DateFormat(SAVE_DATE_FORMAT).format(DateTime.now()));

  StreamSubscription? updateAppointmentApi;

  @override
  void initState() {
    super.initState();

    updateAppointmentApi = appointmentStreamController.stream.listen((streamData) {
      page = 1;
      init(
        todayDate: selectedDate.getFormattedDate(SAVE_DATE_FORMAT),
        startDate: null,
        endDate: null,
      );
    });

    init(startDate: startDate, endDate: endDate, showLoader: false);
  }

  Map<DateTime, List<UpcomingAppointmentModel>> groupAppointmentByDates({required List<UpcomingAppointmentModel> appointmentList}) {
    return groupBy(appointmentList, (UpcomingAppointmentModel appointmentData) => DateFormat(SAVE_DATE_FORMAT).parse(appointmentData.appointmentGlobalStartDate.validate()));
  }

  Future<void> init({bool showLoader = true, String? todayDate, String? startDate, String? endDate}) async {
    if (showLoader) appStore.setLoading(true);
    future = getAppointment(
      pages: page,
      perPage: PER_PAGE,
      appointmentList: appointmentList,
      lastPageCallback: (b) => isLastPage = b,
      todayDate: todayDate,
      startDate: startDate,
      endDate: endDate,
    ).then((value) {
      if (todayDate != null && startDate == null && endDate == null) {
        if (value.isNotEmpty) {
          groupAppointmentByDates(appointmentList: value).forEach((key, value) {
            DateTime date = key;
            _events.putIfAbsent(DateTime(date.year, date.month, date.day), () => value);
          });
        } else {
          DateTime date = DateFormat(SAVE_DATE_FORMAT).parse(todayDate);
          if (_events.containsKey(DateTime(date.year, date.month, date.day))) {
            _events.remove(DateTime(date.year, date.month, date.day));
          }
        }
      }

      if (startDate != null && endDate != null)
        groupAppointmentByDates(appointmentList: value).forEach((key, value) {
          DateTime date = key;
          _events.addAll({
            DateTime(date.year, date.month, date.day): value,
          });
        });
      setState(() {});
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  Future<void> onSwipeRefresh({bool isFirst = false}) async {
    setState(() {
      isRangeSelected = false;
      page = 1;
    });
    appStore.setLoading(true);
    init(
      todayDate: selectedDate.getFormattedDate(SAVE_DATE_FORMAT),
      startDate: null,
      endDate: null,
    );
    return await 1.seconds.delay;
  }

  void showData(DateTime dateTime) async {
    appStore.setLoading(true);
    if (isRangeSelected) {
      appStore.setLoading(false);
      return;
    }
    800.milliseconds.delay;
    selectedDate = DateTime.parse(DateFormat(SAVE_DATE_FORMAT).format(dateTime));
    setState(() {});
    init(
      todayDate: dateTime.getFormattedDate(SAVE_DATE_FORMAT),
      startDate: null,
      endDate: null,
    );
  }

  void onNextPage() {
    if (!isLastPage) {
      appStore.setLoading(true);
      page++;
      init(
        todayDate: selectedDate.getFormattedDate(SAVE_DATE_FORMAT),
        startDate: null,
        endDate: null,
      );
    }
  }

  Future<void> onRangeSelected(Range range) async {
    appStore.setLoading(true);
    isRangeSelected = true;
    page = 1;
    init(
      todayDate: null,
      startDate: range.from.getFormattedDate(SAVE_DATE_FORMAT),
      endDate: range.to.getFormattedDate(SAVE_DATE_FORMAT),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (updateAppointmentApi != null) {
      updateAppointmentApi!.cancel().then((value) {
        log("============== Stream Cancelled ==============");
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
