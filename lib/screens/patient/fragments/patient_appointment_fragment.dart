import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_loader.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/network/appointment_respository.dart';
import 'package:momona_healthcare/screens/patient/components/common_appointment_widget.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/add_appointment_step1.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/add_appointment_step2.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientAppointmentFragment extends StatefulWidget {
  @override
  _PatientAppointmentFragmentState createState() => _PatientAppointmentFragmentState();
}

class _PatientAppointmentFragmentState extends State<PatientAppointmentFragment> {
  int selectIndex = 0;

  DateTime current = DateTime.now();

  Future<List<UpcomingAppointment>>? future;

  List<UpcomingAppointment> appointmentList = [];

  int total = 0;
  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // await getConfiguration();
    future = getPatientAppointmentListNew(appStore.userId.validate(), page: page, appointmentList: appointmentList, getTotalPatient: (b) => total = b, lastPageCallback: (b) => isLastPage = b);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant PatientAppointmentFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
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
              appStore.setStatus('-1');
            } else if (index == 2) {
              appStore.setStatus('3');
            } else if (index == 3) {
              appStore.setStatus('0');
            } else if (index == 4) {
              appStore.setStatus('past');
            }

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

  Widget body() {
    return Stack(
      children: [
        buildStatusWidget(),
        Padding(
          padding: const EdgeInsets.only(top: 46),
          child: SnapHelperWidget<List<UpcomingAppointment>>(
            future: future,
            loadingWidget: Offstage(),
            onSuccess: (snap) {
              if (snap.isEmpty) {
                return NoDataFoundWidget(text: locale.lblNoEncounterFound).center();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          appStore.setBookedFromDashboard(false);
          if (isProEnabled()) {
            AddAppointmentScreenStep1().launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
          } else {
            AddAppointmentScreenStep2().launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
          }
        },
      ),
    );
  }
}
