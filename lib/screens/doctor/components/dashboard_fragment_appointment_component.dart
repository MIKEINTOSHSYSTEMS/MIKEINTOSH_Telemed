import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/components/view_all_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/dashboard_model.dart';
import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';
import 'package:kivicare_flutter/screens/appointment/components/appointment_widget.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardFragmentAppointmentComponent extends StatelessWidget {
  final DashboardModel data;
  final VoidCallback? callback;
  DashboardFragmentAppointmentComponent({required this.data, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewAllLabel(
            label: locale.lblTodaySAppointments,
            labelSize: 18,
            list: data.upcomingAppointment.validate(),
            viewAllShowLimit: 3,
            onTap: () {
              doctorAppStore.setBottomNavIndex(1);
            },
          ),
          if (data.upcomingAppointment.validate().isNotEmpty)
            AnimatedListView(
              shrinkWrap: true,
              itemCount: data.upcomingAppointment.validate().take(3).length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                UpcomingAppointmentModel value = data.upcomingAppointment.validate()[index];
                return AppointmentWidget(
                  upcomingData: value,
                  refreshCall: () {
                    callback?.call();
                  },
                ).paddingSymmetric(vertical: 8);
              },
            )
          else
            NoDataFoundWidget(text: locale.lblNoAppointmentForToday)
        ],
      ),
    );
  }
}
