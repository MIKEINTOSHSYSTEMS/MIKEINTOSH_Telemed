import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/components/view_all_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';
import 'package:kivicare_flutter/screens/appointment/appointment_functions.dart';
import 'package:kivicare_flutter/screens/appointment/components/appointment_dashboard_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class DashBoardFragmentUpcomingAppointmentComponent extends StatelessWidget {
  final List<UpcomingAppointmentModel> upcomingAppointment;
  DashBoardFragmentUpcomingAppointmentComponent({required this.upcomingAppointment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          onTap: () {
            patientStore.setBottomNavIndex(1);
          },
          label: locale.lblUpcomingAppointments,
          list: upcomingAppointment.validate(),
          viewAllShowLimit: 4,
        ).paddingSymmetric(horizontal: 16, vertical: 8),
        if (upcomingAppointment.length > 0)
          HorizontalList(
            spacing: 16,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            itemCount: upcomingAppointment.length,
            itemBuilder: (context, index) {
              return AppointmentDashboardComponent(upcomingData: upcomingAppointment[index]);
            },
          )
        else
          NoDataFoundWidget(
            text: locale.lblNoAppointments,
            iconSize: 40,
            onRetry: () {
              appointmentWidgetNavigation(context);
            },
            retryText: locale.lblBook + " ${locale.lblAppointments}",
          )
      ],
    );
  }
}
