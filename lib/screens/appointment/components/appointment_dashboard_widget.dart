import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/image_border_component.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/screens/appointment/components/appointment_quick_view.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentDashboardComponent extends StatelessWidget {
  final UpcomingAppointmentModel upcomingData;

  const AppointmentDashboardComponent({required this.upcomingData});

  void _handleViewButton(BuildContext context) {
    showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(locale.lblAppointmentSummary, style: primaryTextStyle(color: appPrimaryColor)).expand(),
          16.width,
          StatusWidget(
            status: upcomingData.status.validate(),
            isAppointmentStatus: true,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          ),
        ],
      ),
      builder: (p0) {
        return AppointmentQuickView(upcomingAppointment: upcomingData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: context.width() - 32,
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageBorder(
                src: isDoctor() ? upcomingData.patientProfileImg.validate() : upcomingData.doctorProfileImg.validate(),
                height: 40,
                width: 40,
                nameInitial: isPatient() ? (upcomingData.doctorName.validate(value: 'D')[0]) : upcomingData.patientName.validate(value: 'P')[0],
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(upcomingData.id.validate().prefixText(value: '#'), style: secondaryTextStyle(color: primaryColor)),
                  2.height,
                  Text(getRoleWiseAppointmentFirstText(upcomingData), style: boldTextStyle()),
                  if (upcomingData.getVisitTypesInString.validate().isNotEmpty) 4.height,
                  if (upcomingData.getVisitTypesInString.validate().isNotEmpty)
                    ReadMoreText(
                      upcomingData.getVisitTypesInString.validate(),
                      trimLines: 1,
                      style: secondaryTextStyle(),
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: locale.lblReadMore,
                      trimExpandedText: locale.lblReadLess,
                      locale: Localizations.localeOf(context),
                    ),
                ],
              ).expand(),
              StatusWidget(
                isAppointmentStatus: true,
                status: upcomingData.status.validate(),
              ),
            ],
          ),
          16.height,
          Container(
            width: context.width() - 64,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ic_appointment.iconImage(size: 16).paddingLeft(16),
                10.width,
                Text('${upcomingData.appointmentDateFormat}', style: primaryTextStyle(size: 14)).expand(),
              ],
            ),
          ),
          8.height
        ],
      ),
    ).appOnTap(() {
      _handleViewButton(context);
    });
  }
}
