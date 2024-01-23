import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/body_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/holiday_model.dart';
import 'package:momona_healthcare/network/doctor_list_repository.dart';
import 'package:momona_healthcare/network/holiday_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/add_holiday_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class HolidayScreen extends StatefulWidget {
  @override
  _HolidayScreenState createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getDoctor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void deleteHoliday(int id) async {
    appStore.setLoading(true);
    Map request = {"id": id};
    await deleteHolidayData(request).then((value) {
      toast(locale.lblHolidayDeleted);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
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

  Widget buildBodyWidget() {
    return FutureBuilder<HolidayModel>(
      future: getHolidayResponse(),
      builder: (_, snap) {
        if (snap.hasData) {
          if (snap.data!.holidayData.validate().isEmpty) return NoDataFoundWidget().center();

          return AnimatedScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
            disposeScrollController: true,
            listAnimationType: ListAnimationType.FadeIn,
            physics: AlwaysScrollableScrollPhysics(),
            slideConfiguration: SlideConfiguration(verticalOffset: 400),
            onSwipeRefresh: () async {
              init();
              getHolidayResponse();
              return await 2.seconds.delay;
            },
            children: [
              Text(locale.lblHolidays + ' (${snap.data!.holidayData!.length.validate()})', style: boldTextStyle(size: titleTextSize)),
              16.height,
              AnimatedWrap(
                spacing: 16,
                runSpacing: 16,
                itemCount: snap.data!.holidayData.validate().length,
                listAnimationType: ListAnimationType.Scale,
                itemBuilder: (context, index) {
                  HolidayData data = snap.data!.holidayData.validate()[index];
                  int totalDays = (DateTime.parse(data.end_date!).difference(DateTime.parse(data.start_date!))).inDays;
                  int pendingDays = DateTime.parse(data.end_date!).difference(DateTime.now()).inDays;
                  bool isPending = (DateTime.parse(data.end_date!).isAfter(DateTime.now()));

                  return Container(
                    width: context.width() / 2 - 24,
                    decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor, border: Border.all(color: context.dividerColor)),
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (data.module_type == 'doctor')
                                  if (listAppStore.doctorList.firstWhereOrNull((element) => element!.iD == data.module_id.toInt()) != null)
                                    Text(
                                      '${listAppStore.doctorList.firstWhereOrNull((element) => element!.iD == data.module_id.toInt())!.display_name}',
                                      style: boldTextStyle(size: 16),
                                    ),
                                if (data.module_type != 'doctor') Text(locale.lblClinic, style: boldTextStyle(size: 18)),
                                if (listAppStore.doctorList.firstWhereOrNull((element) => element!.iD == data.module_id.toInt()) != null) 10.height,
                                Text('${data.start_date.validate().getFormattedDate(APPOINTMENT_DATE_FORMAT).validate()}', style: primaryTextStyle(size: 14)),
                                4.height,
                                Container(height: 1, width: 3, color: Colors.black),
                                4.height,
                                Text('${data.end_date.validate().getFormattedDate(APPOINTMENT_DATE_FORMAT).validate()}', style: primaryTextStyle(size: 14)),
                                10.height,
                                Text(locale.lblAfter + ' ${pendingDays == 0 ? '1' : pendingDays} ' + locale.lblDays, style: boldTextStyle(size: 16)).visible(isPending),
                                Text(locale.lblWasOffFor + ' ${totalDays == 0 ? '1' : totalDays} ' + locale.lblDays, style: boldTextStyle(size: 16)).visible(!isPending),
                              ],
                            ).expand(),
                          ],
                        ).paddingAll(16),
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 6,
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: boxDecorationDefault(
                              borderRadius: radiusOnly(topLeft: defaultRadius, bottomLeft: defaultRadius),
                              color: getHolidayStatusColor(isPending).withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).onTap(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    () async {
                      await AddHolidayScreen(holidayData: data).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      setState(() {});
                      init();
                      getHolidayResponse();
                    },
                  );
                },
              ),
            ],
          );
        }
        return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblYourHolidays, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Body(
        child: buildBodyWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await AddHolidayScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide).then((value) {
            if (value) {
              setState(() {});
              init();
              getHolidayResponse();
            }
          });
        },
      ),
    );
  }
}
