import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_loader.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/network/appointment_respository.dart';
import 'package:momona_healthcare/screens/patient/components/common_appointment_widget.dart';
import 'package:momona_healthcare/screens/receptionist/screens/appointment/r_appointment_screen1.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class RAppointmentFragment extends StatefulWidget {
  @override
  State<RAppointmentFragment> createState() => _RAppointmentFragmentState();
}

class _RAppointmentFragmentState extends State<RAppointmentFragment> {
  int selectIndex = 0;

  DateTime current = DateTime.now();

  Future<List<UpcomingAppointment>>? future;

  List<UpcomingAppointment> appointmentList = [];

  int totalAppointment = 0;
  String status = '1';

  int total = 0;
  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getReceptionistAppointmentList(
      todayDate: DateTime.now().getFormattedDate(CONVERT_DATE),
      appointmentList: appointmentList,
      status: appStore.mStatus,
      page: page,
      getTotalAppointment: (p0) => totalAppointment = p0,
      lastPageCallback: (p0) => isLastPage,
    );
  }

  Widget buildStatusWidget() {
    return HorizontalList(
      itemCount: appointmentStatusList.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        bool isSelected = selectIndex == index;
        return GestureDetector(
          onTap: () {
            selectIndex = index;
            setState(() {});

            if (index == 0) {
              appStore.setStatus('all');
            } else if (index == 1) {
              appStore.setStatus('1');
            } else if (index == 2) {
              appStore.setStatus('3');
            } else if (index == 3) {
              appStore.setStatus('0');
            } else if (index == 4) {
              appStore.setStatus('past');
            }
            page = 1;
            init();
          },
          child: Container(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
            decoration: boxDecorationDefault(color: isSelected ? context.primaryColor : context.cardColor, borderRadius: radius()),
            child: Text(appointmentStatusList[index], style: primaryTextStyle(color: isSelected ? Colors.white : textPrimaryColorGlobal, size: 14)),
          ),
        );
      },
    ).paddingTop(16);
  }

  Widget buildBodyWidget() {
    return Stack(
      children: [
        buildStatusWidget(),
        Padding(
          padding: const EdgeInsets.only(top: 66),
          child: SnapHelperWidget<List<UpcomingAppointment>>(
            future: future,
            loadingWidget: Offstage(),
            onSuccess: (snap) {
              if (snap.isEmpty) {
                return Builder(builder: (context) {
                  return NoDataFoundWidget(text: locale.lblNoEncounterFound).center().visible(!appStore.isLoading);
                });
              }

              return AnimatedListView(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snap.length,
                disposeScrollController: true,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
                onSwipeRefresh: () async {
                  page = 1;
                  init();

                  setState(() {});
                  return await 2.seconds.delay;
                },
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    init();
                    setState(() {});
                  }
                },
                shrinkWrap: true,
                listAnimationType: ListAnimationType.Slide,
                slideConfiguration: SlideConfiguration(verticalOffset: 400),
                itemBuilder: (_, index) => CommonAppointmentWidget(index: index, upcomingData: snap[index]).paddingSymmetric(vertical: 8),
              );
            },
          ),
        ),
        AppLoader(),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => RAppointment1Screen().launch(context),
      ),
      body: buildBodyWidget(),
    );
  }
}
