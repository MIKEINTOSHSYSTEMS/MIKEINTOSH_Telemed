import 'dart:core';

import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/common/appointment_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/network/appointment_respository.dart';
import 'package:momona_healthcare/screens/doctor/screens/appointment/doctor_add_appointment_step1_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/widgets/calender/date_utils.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/widgets/calender/flutter_clean_calendar.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentFragment extends StatefulWidget {
  @override
  _AppointmentFragmentState createState() => _AppointmentFragmentState();
}

class _AppointmentFragmentState extends State<AppointmentFragment> {
  Map<DateTime, List> _events = Map<DateTime, List>();

  List<UpcomingAppointment> filterList = [];

  String startDate = DateTime(DateTime.now().year, DateTime.now().month, 1).getFormattedDate(CONVERT_DATE);
  String endDate = DateTime(DateTime.now().year, DateTime.now().month, Utils.lastDayOfMonth(DateTime.now()).day).getFormattedDate(CONVERT_DATE);

  @override
  void initState() {
    super.initState();
    LiveStream().on(APP_UPDATE, (isUpdate) {
      if (isUpdate as bool) {
        init();
      }
    });
    init();
  }

  init() async {
    loadData();
  }

  void loadData() async {
    appStore.setLoading(true);
    await getAppointmentData(startDate: startDate, endDate: endDate).then(
      (value) {
        value.appointmentData!.forEach(
          (element) {
            DateTime date = DateTime.parse(element.appointment_start_date!);
            _events.addAll(
              {
                DateTime(date.year, date.month, date.day): [
                  {'name': 'Event A', 'isDone': true, 'time': '9 - 10 AM'}
                ]
              },
            );
          },
        );
        setState(() {});
        if (DateTime.parse(startDate).month == DateTime.now().month) {
          showData(DateTime.now());
        }
      },
    ).catchError(
      (e) {
        appStore.setLoading(false);
        toast(e.toString());
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void showData(DateTime dateTime) async {
    appStore.setLoading(true);
    filterList.clear();

    await getAppointmentInCalender(todayDate: dateTime.getFormattedDate(CONVERT_DATE), page: 1).then((value) {
      filterList.addAll(value.appointmentData!);
      setState(() {});
    }).catchError(((e) {
      toast(e.toString());
    }));

    appStore.setLoading(false);
  }

  void deleteAppointmentById(int id) async {
    Map<String, dynamic> request = {"id": id};

    await deleteAppointment(request).then((value) {
      LiveStream().emit(UPDATE, true);
      LiveStream().emit(APP_UPDATE, true);
      LiveStream().emit(DELETE, true);
      toast(locale.lblAppointmentDeleted);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void didUpdateWidget(covariant AppointmentFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(APP_UPDATE);
  }

  Widget buildBodyWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
            child: Calendar(
              startOnMonday: true,
              weekDays: [locale.lblMon, locale.lblTue, locale.lblWed, locale.lblThu, locale.lblFri, locale.lblSat, locale.lblSun],
              events: _events,
              onDateSelected: (e) => showData(e),
              onRangeSelected: (Range range) {
                startDate = range.from.getFormattedDate(CONVERT_DATE);
                endDate = range.to.getFormattedDate(CONVERT_DATE);
                loadData();
              },
              isExpandable: true,
              locale: appStore.selectedLanguage,
              isExpanded: false,
              eventColor: appSecondaryColor,
              selectedColor: primaryColor,
              todayColor: primaryColor,
              bottomBarArrowColor: context.iconColor,
              dayOfWeekStyle: TextStyle(color: appStore.isDarkModeOn ? Colors.white : Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
            ),
          ),
          42.height,
          Text(locale.lblTodaySAppointments, style: boldTextStyle(size: titleTextSize)),
          4.height,
          Text(locale.lblSwipeMassage, style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
          16.height,
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filterList.length,
            itemBuilder: (BuildContext context, int index) {
              return AppointmentWidget(upcomingData: filterList[index], index: index).paddingSymmetric(vertical: 8);
            },
          ).visible(!appStore.isLoading, defaultWidget: LoaderWidget()),
          16.height,
          NoDataFoundWidget(text: locale.lblNotAppointmentForThisDay, iconSize: 130).visible(filterList.isEmpty && !appStore.isLoading).center(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bool? res = await DoctorAddAppointmentStep1Screen(id: getIntAsync(USER_ID)).launch(context);
          if (res ?? false) setState(() {});
        },
      ),
    );
  }
}
