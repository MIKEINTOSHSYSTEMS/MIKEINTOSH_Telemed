import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/empty_error_state_component.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/dashboard_model.dart';
import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';
import 'package:kivicare_flutter/network/appointment_repository.dart';
import 'package:kivicare_flutter/network/dashboard_repository.dart';
import 'package:kivicare_flutter/screens/appointment/components/appointment_widget.dart';
import 'package:kivicare_flutter/screens/doctor/components/dashboard_fragment_analytics_component.dart';
import 'package:kivicare_flutter/screens/doctor/components/dashboard_fragment_appointment_component.dart';
import 'package:kivicare_flutter/screens/doctor/fragments/appointment_fragment.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/doctor_dashboard_shimmer_fragment.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/cached_value.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:kivicare_flutter/utils/widgets/calender/flutter_clean_calendar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:async';

import 'package:intl/intl.dart';

import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/widgets/calender/date_utils.dart';

class RDashboardFragment extends StatefulWidget {
  @override
  _RDashboardFragmentState createState() => _RDashboardFragmentState();
}

class _RDashboardFragmentState extends State<RDashboardFragment> {
  Future<DashboardModel>? future;

  Map<DateTime, List> _events = {};

  Future<List<UpcomingAppointmentModel>>? futureAppointment;

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
    init();
    updateAppointmentApi = appointmentStreamController.stream.listen((streamData) {
      page = 1;
      getAppointmentApi(
        todayDate: selectedDate.getFormattedDate(SAVE_DATE_FORMAT),
        startDate: null,
        endDate: null,
      );
    });
  }

  void init() async {
    future = getUserDashBoardAPI().then((value) {
      setState(() {});
      getAppointmentApi(startDate: startDate, endDate: endDate, showLoader: false);
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  Map<DateTime, List<UpcomingAppointmentModel>> groupAppointmentByDates({required List<UpcomingAppointmentModel> appointmentList}) {
    return groupBy(appointmentList, (UpcomingAppointmentModel appointmentData) => DateFormat(SAVE_DATE_FORMAT).parse(appointmentData.appointmentGlobalStartDate.validate()));
  }

  Future<void> getAppointmentApi({bool showLoader = true, String? todayDate, String? startDate, String? endDate}) async {
    futureAppointment = getReceptionistAppointmentList(
      appointmentList: appointmentList,
      lastPageCallback: (b) => isLastPage = b,
      status: 'All',
      page: page,
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
    getAppointmentApi(
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

    getAppointmentApi(
      todayDate: dateTime.getFormattedDate(SAVE_DATE_FORMAT),
      startDate: null,
      endDate: null,
    );
  }

  void onNextPage() {
    if (!isLastPage) {
      appStore.setLoading(true);
      page++;
      getAppointmentApi(
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
    getAppointmentApi(
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SnapHelperWidget<DashboardModel>(
        initialData: cachedReceptionistDashboardModel,
        future: future,
        errorBuilder: (error) {
          return NoDataWidget(
            imageWidget: Image.asset(ic_somethingWentWrong, height: 180, width: 180),
            title: error.toString(),
          );
        },
        errorWidget: ErrorStateWidget(),
        loadingWidget: DoctorDashboardShimmerFragment(),
        onSuccess: (data) {
          return AnimatedScrollView(
            padding: EdgeInsets.only(bottom: 60),
            children: [
              DashboardFragmentAnalyticsComponent(data: data),
              if (data.upcomingAppointment.validate().isNotEmpty)
                DashboardFragmentAppointmentComponent(
                  data: data,
                  callback: () {
                    init();
                  },
                ),
              if (data.upcomingAppointment.validate().isEmpty)
                SnapHelperWidget(
                  future: futureAppointment,
                  loadingWidget: LoaderWidget().center(),
                  onSuccess: (data) {
                    return Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(locale.lblTodaySAppointments, style: boldTextStyle(size: fragmentTextSize)),
                                8.width,
                                Marquee(child: Text("(${selectedDate.getDateInString(format: CONFIRM_APPOINTMENT_FORMAT)})", style: boldTextStyle(size: 14, color: context.primaryColor))).expand(),
                              ],
                            ),
                            4.height,
                            Text(locale.lblSwipeMassage, style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
                          ],
                        ).paddingOnly(top: 16, right: 16, left: 16),
                        Container(
                          margin: EdgeInsets.all(16),
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                          child: CleanCalendar(
                            startOnMonday: true,
                            weekDays: [locale.lblMon, locale.lblTue, locale.lblWed, locale.lblThu, locale.lblFri, locale.lblSat, locale.lblSun],
                            events: _events,
                            onDateSelected: (e) {
                              selectedDate = DateTime.parse(DateFormat(SAVE_DATE_FORMAT).format(e));
                              setState(() {});
                            },
                            initialDate: selectedDate,
                            onRangeSelected: (Range range) {
                              onRangeSelected(range);
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
                        AnimatedWrap(
                          runSpacing: 16,
                          spacing: 16,
                          children: List.generate(groupAppointmentByDates(appointmentList: data)[selectedDate].validate().length, (index) {
                            UpcomingAppointmentModel upcomingData = groupAppointmentByDates(appointmentList: data)[selectedDate].validate()[index];
                            return AppointmentWidget(upcomingData: upcomingData);
                          }),
                        ).paddingSymmetric(horizontal: 16).visible(
                              groupAppointmentByDates(appointmentList: data)[selectedDate].validate().isNotEmpty,
                              defaultWidget: NoDataFoundWidget(
                                text: selectedDate.getFormattedDate(SAVE_DATE_FORMAT) == DateTime.now().getFormattedDate(SAVE_DATE_FORMAT)
                                    ? locale.lblNoAppointmentForToday
                                    : locale.lblNoAppointmentForThisDay,
                                iconSize: 130,
                              ).center(),
                            )
                      ],
                    );
                  },
                )
            ],
          ).visible(!appStore.isLoading, defaultWidget: DoctorDashboardShimmerFragment().visible(appStore.isLoading));
        },
      ),
    );
  }
}
