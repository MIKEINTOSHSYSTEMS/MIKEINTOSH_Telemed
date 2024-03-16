import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/internet_connectivity_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/holiday_model.dart';
import 'package:momona_healthcare/network/holiday_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/holiday/add_holiday_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/holiday/components/holiday_widget.dart';
import 'package:momona_healthcare/screens/shimmer/screen/holiday_shimmer_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class HolidayScreen extends StatefulWidget {
  @override
  _HolidayScreenState createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  Future<HolidayModel>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool showLoader = false}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }
    future = getHolidayResponseAPI().whenComplete(() {
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HolidayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(locale.lblHolidays, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
        body: InternetConnectivityWidget(
          retryCallback: () async {
            await 2.seconds.delay;
            setState(() {});
          },
          child: Stack(
            children: [
              SnapHelperWidget<HolidayModel>(
                future: future,
                loadingWidget: HolidayShimmerScreen(),
                errorWidget: ErrorStateWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    imageWidget: Image.asset(ic_somethingWentWrong, height: 180, width: 180),
                    title: locale.lblSomethingWentWrong,
                  ).center();
                },
                onSuccess: (snap) {
                  if (snap.holidayData.validate().isEmpty)
                    return EmptyStateWidget(
                      emptyWidgetTitle: locale.lblNo + " " + locale.lblHolidays + " " + locale.lblSchedule.suffixText(value: 'd'),
                    ).center();
                  return AnimatedScrollView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
                    disposeScrollController: true,
                    listAnimationType: ListAnimationType.None,
                    physics: AlwaysScrollableScrollPhysics(),
                    slideConfiguration: SlideConfiguration(verticalOffset: 400),
                    onSwipeRefresh: () async {
                      init();
                      return await 2.seconds.delay;
                    },
                    children: [
                      if (isVisible(SharedPreferenceKey.kiviCareClinicScheduleEditKey))
                        Text('${locale.lblNote} : ${locale.lblHolidayTapMsg}', style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
                      if (isVisible(SharedPreferenceKey.kiviCareClinicScheduleEditKey)) 8.height,
                      AnimatedWrap(
                        spacing: 16,
                        runSpacing: 16,
                        listAnimationType: listAnimationType,
                        children: snap.holidayData.validate().map(
                          (holidayData) {
                            return HolidayWidget(data: holidayData).appOnTap(
                              () async {
                                if (isVisible(SharedPreferenceKey.kiviCareClinicScheduleEditKey)) {
                                  List<DateTime> dates = getDatesBetweenTwoDates(
                                      DateFormat(SAVE_DATE_FORMAT).parse(holidayData.holidayStartDate.validate()), DateFormat(SAVE_DATE_FORMAT).parse(holidayData.holidayEndDate.validate()));

                                  bool isPending = getDateDifference(holidayData.holidayStartDate.validate()) <= 0;
                                  String today = DateFormat(SAVE_DATE_FORMAT).format(DateTime.now());
                                  bool isOnLeave = dates.map((date) => DateFormat(SAVE_DATE_FORMAT).format(date)).contains(today);
                                  if (isPending || isOnLeave)
                                    await AddHolidayScreen(holidayData: holidayData).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                                      if (value ?? false) init(showLoader: true);
                                    });
                                  else
                                    toast(locale.lblEditHolidayRestriction);
                                }
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  );
                },
              ),
              LoaderWidget().center().visible(appStore.isLoading)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            if (appStore.isConnectedToInternet)
              await AddHolidayScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                if (value ?? false) {
                  init(showLoader: true);
                }
              });
            else {
              toast(locale.lblNoInternetMsg);
            }
          },
        ).visible(isVisible(SharedPreferenceKey.kiviCareClinicScheduleAddKey)),
      );
    });
  }
}
