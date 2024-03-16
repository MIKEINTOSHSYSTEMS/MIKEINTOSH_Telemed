// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/body_widget.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/network/appointment_repository.dart';
import 'package:momona_healthcare/screens/appointment/appointment_functions.dart';
import 'package:momona_healthcare/screens/doctor/components/appointment_fragment_appointment_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/appointment_shimmer_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/cached_value.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:momona_healthcare/utils/widgets/calender/date_utils.dart';
import 'package:momona_healthcare/utils/widgets/calender/flutter_clean_calendar.dart';
import 'package:nb_utils/nb_utils.dart';

StreamController appointmentStreamController = StreamController.broadcast();

class AppointmentFragment extends StatefulWidget {
  @override
  State<AppointmentFragment> createState() => _AppointmentFragmentState();
}

class _AppointmentFragmentState extends State<AppointmentFragment> {
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
        showLoader: true,
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
    return Scaffold(
      body: AnimatedScrollView(
        padding: EdgeInsets.only(bottom: 60),
        onSwipeRefresh: onSwipeRefresh,
        onNextPage: onNextPage,
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
                appStore.setLoading(true);
                showData(e);
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
          SnapHelperWidget<List<UpcomingAppointmentModel>>(
            initialData: cachedDoctorAppointment,
            future: future,
            errorBuilder: (error) {
              return NoDataWidget(
                imageWidget: Image.asset(
                  ic_somethingWentWrong,
                  height: 180,
                  width: 180,
                ),
                title: error.toString(),
              );
            },
            errorWidget: ErrorStateWidget(),
            loadingWidget: AnimatedWrap(
              listAnimationType: ListAnimationType.None,
              runSpacing: 16,
              spacing: 16,
              children: [
                AppointmentShimmerComponent(),
                AppointmentShimmerComponent(),
                AppointmentShimmerComponent(),
              ],
            ).paddingSymmetric(horizontal: 16),
            onSuccess: (snap) {
              return AppointmentFragmentAppointmentComponent(
                data: groupAppointmentByDates(appointmentList: snap)[selectedDate].validate(),
                refreshCallForRefresh: () {
                  onSwipeRefresh(isFirst: true);
                },
              ).visible(
                groupAppointmentByDates(appointmentList: snap)[selectedDate].validate().isNotEmpty,
                defaultWidget: Observer(
                  builder: (context) {
                    if (groupAppointmentByDates(appointmentList: snap)[selectedDate].validate().isEmpty && !appStore.isLoading)
                      return NoDataFoundWidget(
                        text:
                            selectedDate.getFormattedDate(SAVE_DATE_FORMAT) == DateTime.now().getFormattedDate(SAVE_DATE_FORMAT) ? locale.lblNoAppointmentForToday : locale.lblNoAppointmentForThisDay,
                      ).center();
                    else if (page > 1 && appStore.isLoading)
                      return LoaderWidget().center();
                    else
                      return AnimatedWrap(
                        listAnimationType: ListAnimationType.None,
                        runSpacing: 16,
                        spacing: 16,
                        children: [
                          AppointmentShimmerComponent(),
                          AppointmentShimmerComponent(),
                          AppointmentShimmerComponent(),
                        ],
                      ).paddingSymmetric(horizontal: 16).visible(appStore.isLoading && snap.isEmpty);
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          appointmentWidgetNavigation(context);
        },
      ).visible(isVisible(SharedPreferenceKey.kiviCareAppointmentAddKey)),
    );
  }
}
