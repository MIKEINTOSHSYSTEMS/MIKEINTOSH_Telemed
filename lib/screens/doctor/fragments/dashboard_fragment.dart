import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momona_healthcare/components/common/appointment_list_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/network/dashboard_repository.dart';
import 'package:momona_healthcare/screens/doctor/components/dashboard_count_widget.dart';
import 'package:momona_healthcare/screens/doctor/components/weekly_chart_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardFragment extends StatefulWidget {
  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  List<DashBoardCountWidget> dashboardCount = [];
  Future<DoctorDashboardModel>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getDoctorDashBoard();
  }

  @override
  void didUpdateWidget(covariant DashboardFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Widget buildAnalyticsWidget({required DoctorDashboardModel data}) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(locale.lblYourNumber, style: boldTextStyle(size: titleTextSize)),
          40.height,
          AnimatedWrap(
            itemCount: 3,
            spacing: 14,
            listAnimationType: ListAnimationType.Scale,
            itemBuilder: (context, index) {
              if (index == 0) {
                return DashBoardCountWidget(
                  title: locale.lblTodayAppointments,
                  color1: appSecondaryColor,
                  subTitle: locale.lblTotalTodayAppointments,
                  count: data.upcoming_appointment_total.validate(),
                  icon: FontAwesomeIcons.calendarCheck,
                );
              } else if (index == 1) {
                return DashBoardCountWidget(
                  title: locale.lblTotalAppointment,
                  color1: appPrimaryColor,
                  subTitle: locale.lblTotalVisitedAppointment,
                  count: data.total_appointment.validate(),
                  icon: FontAwesomeIcons.calendarCheck,
                );
              } else if (index == 2) {
                return DashBoardCountWidget(
                  title: locale.lblTotalPatient,
                  color1: appSecondaryColor,
                  subTitle: locale.lblTotalVisitedPatients,
                  count: data.total_patient.validate(),
                  icon: FontAwesomeIcons.userInjured,
                );
              }

              return Offstage();
            },
          )
        ],
      ),
    );
  }

  Widget buildChartWidget({required DoctorDashboardModel data}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Text(locale.lblWeeklyAppointments, style: boldTextStyle(size: titleTextSize)).paddingOnly(left: 10),
          10.height,
          Container(
            height: 220,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.only(left: 16, right: 16, top: 24),
            decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
            child: WeeklyChartComponent(weeklyAppointment: data.weekly_appointment.validate().isNotEmpty ? data.weekly_appointment.validate() : emptyGraphList).withWidth(
              context.width(),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAppointmentWidget({required DoctorDashboardModel data}) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,
          Text(locale.lblTodaySAppointments, style: boldTextStyle(size: 18)),
          4.height,
          Text(locale.lblSwipeMassage, style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
          16.height,
          AppointmentListWidget(upcomingAppointment: data.upcoming_appointment.validate())
        ],
      ),
    );
  }

  Widget buildBodyWidget({required DoctorDashboardModel data}) {
    return AnimatedScrollView(
      children: [
        buildAnalyticsWidget(data: data),
        buildChartWidget(data: data),
        buildAppointmentWidget(data: data),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DoctorDashboardModel>(
        future: future,
        builder: (_, snap) {
          if (snap.hasData) {
            return buildBodyWidget(data: snap.data!);
          }
          return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
        },
      ),
    );
  }
}
