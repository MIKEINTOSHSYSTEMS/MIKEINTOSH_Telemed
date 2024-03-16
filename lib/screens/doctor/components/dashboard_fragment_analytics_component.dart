import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/dashboard_model.dart';
import 'package:momona_healthcare/screens/doctor/components/dashboard_count_widget.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardFragmentAnalyticsComponent extends StatelessWidget {
  final DashboardModel data;
  DashboardFragmentAnalyticsComponent({required this.data});

  @override
  Widget build(BuildContext context) {
    List<Widget> child = [
      if ((isDoctor() && isVisible(SharedPreferenceKey.kiviCareDashboardTotalTodayAppointmentKey)) || (isReceptionist() && isVisible(SharedPreferenceKey.kiviCareDashboardTotalDoctorKey)))
        DashBoardCountWidget(
          title: isReceptionist() ? locale.lblTotalDoctors : locale.lblTodayAppointments,
          color1: appSecondaryColor,
          count: isReceptionist() ? data.totalDoctor : data.upcomingAppointmentTotal.validate(),
          icon: FontAwesomeIcons.calendarCheck,
        ),
      if (isVisible(SharedPreferenceKey.kiviCareDashboardTotalAppointmentKey))
        DashBoardCountWidget(
          title: locale.lblTotalAppointment,
          color1: appPrimaryColor,
          count: data.totalAppointment.validate(),
          icon: FontAwesomeIcons.calendarCheck,
        ),
      if (isVisible(SharedPreferenceKey.kiviCareDashboardTotalPatientKey))
        DashBoardCountWidget(
          title: locale.lblTotalPatient,
          color1: appSecondaryColor,
          count: data.totalPatient.validate(),
          icon: FontAwesomeIcons.userInjured,
        )
    ];
    return Wrap(
      spacing: 14,
      crossAxisAlignment: child.length > 2 ? WrapCrossAlignment.start : WrapCrossAlignment.center,
      children: child.map((e) => e).toList(),
    ).paddingTop(16);
  }
}
