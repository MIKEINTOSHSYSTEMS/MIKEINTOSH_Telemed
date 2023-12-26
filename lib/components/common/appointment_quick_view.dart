import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/common_row_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentQuickView extends StatelessWidget {
  final UpcomingAppointment upcomingAppointment;

  AppointmentQuickView({required this.upcomingAppointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            8.height,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${upcomingAppointment.patient_name.validate().capitalizeFirstLetter()}",
                  style: boldTextStyle(color: primaryColor, size: 20),
                ),
                24.height,
                Wrap(
                  runSpacing: 8,
                  children: [
                    if (isReceptionist()) CommonRowWidget(title: locale.lblDoctor, value: upcomingAppointment.doctor_name.validate(), isMarquee: true),
                    CommonRowWidget(title: locale.lblService, value: '${upcomingAppointment.visit_type!.map((e) => e.service_name.validate()).join(" , ")}'),
                    CommonRowWidget(title: locale.lblDate, value: upcomingAppointment.appointment_start_date.validate().getFormattedDate(APPOINTMENT_DATE_FORMAT)),
                    CommonRowWidget(
                        title: locale.lblTime,
                        value:
                            '${DateFormat(TIME_WITH_SECONDS).parse(upcomingAppointment.appointment_start_time!).getFormattedDate(FORMAT_12_HOUR)} - ${DateFormat(TIME_WITH_SECONDS).parse(upcomingAppointment.appointment_end_time!).getFormattedDate(FORMAT_12_HOUR)}'),
                    CommonRowWidget(title: locale.lblDesc, value: upcomingAppointment.description.validate().trim().isNotEmpty ? upcomingAppointment.description.validate() : 'NA'),
                  ],
                ),
                24.height,
                DottedBorderWidget(
                  color: appPrimaryColor,
                  gap: 3,
                  radius: 8,
                  strokeWidth: 1,
                  child: Container(
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: context.scaffoldBackgroundColor),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.lblPRICE.capitalizeFirstLetter(), style: primaryTextStyle()),
                        10.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            upcomingAppointment.visit_type.validate().length,
                            (index) => Row(
                              children: [
                                Text(
                                  "${upcomingAppointment.visit_type![index].service_name}",
                                  style: secondaryTextStyle(),
                                ).expand(),
                                Text(
                                  "${appStore.currency.validate()}${upcomingAppointment.visit_type![index].charges.validate()}",
                                  style: boldTextStyle(color: appStore.isDarkModeOn ? white : appPrimaryColor),
                                ),
                              ],
                            ).paddingSymmetric(vertical: 4),
                          ),
                        ),
                        4.height,
                        Row(
                          children: [
                            Text(locale.lblTotal, style: secondaryTextStyle()).expand(),
                            Text(
                              '${appStore.currency.validate()}${upcomingAppointment.all_service_charges}',
                              style: boldTextStyle(color: appStore.isDarkModeOn ? white : appPrimaryColor),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 4),
                      ],
                    ),
                  ),
                ),
                if (upcomingAppointment.appointment_report.validate().isNotEmpty) Divider(height: 16),
                if (upcomingAppointment.appointment_report.validate().isNotEmpty) Text(locale.lblMedicalReports, style: boldTextStyle()),
                if (upcomingAppointment.appointment_report.validate().isNotEmpty)
                  Column(
                    children: List.generate(
                      upcomingAppointment.appointment_report!.length,
                      (index) {
                        AppointmentReport data = upcomingAppointment.appointment_report![index];

                        return GestureDetector(
                          onTap: () {
                            commonLaunchUrl("${data.url}");
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: boxDecorationDefault(
                              color: context.cardColor,
                              boxShadow: defaultBoxShadow(spreadRadius: 0, blurRadius: 0),
                              border: Border.all(color: context.dividerColor),
                            ),
                            child: Row(
                              children: [
                                Text('${locale.lblMedicalReports} ${index + 1}', style: boldTextStyle()).expand(),
                                Icon(Icons.arrow_forward_ios_outlined, size: 16),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
