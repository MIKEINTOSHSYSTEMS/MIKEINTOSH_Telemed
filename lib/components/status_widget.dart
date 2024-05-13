import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/common.dart';

class StatusWidget extends StatelessWidget {
  final String status;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final bool isAppointmentStatus;
  final bool isPaymentStatus;
  final bool isActivityStatus;
  final bool isServiceActivityStatus;
  final bool isEncounterStatus;
  final bool isClinicStatus;
  final TextStyle? textStyle;
  final double? width;

  StatusWidget(
      {Key? key,
      required this.status,
      this.width,
      this.backgroundColor,
      this.borderRadius,
      this.isAppointmentStatus = false,
      this.isPaymentStatus = false,
      this.isActivityStatus = false,
      this.isEncounterStatus = false,
      this.textStyle,
      this.padding,
      this.isClinicStatus = false,
      this.isServiceActivityStatus = false})
      : super(key: key);

  String getStatusText() {
    if (isAppointmentStatus) {
      return getStatus(status.validate());
    } else if (isPaymentStatus) {
      return getPaymentStatus(status).toUpperCase();
    } else if (isEncounterStatus) {
      return getEncounterStatus(status).toUpperCase();
    } else if (isClinicStatus) {
      return getClinicStatus(status).toUpperCase();
    } else if (isServiceActivityStatus) {
      return getServiceActivityStatus(status).toUpperCase();
    } else if (isActivityStatus) {
      return getUserActivityStatus(status);
    }

    return '';
  }

  Color? getStatusBackgroundColor() {
    if (isAppointmentStatus) {
      return getAppointStatusColor(status);
    } else if (isPaymentStatus) {
      return commonStatusColor(status);
    } else if (isEncounterStatus) {
      return getEncounterStatusColor(status);
    } else if (isClinicStatus) {
      return commonStatusColor(status);
    } else if (isServiceActivityStatus) {
      return commonStatusColor(status);
    } else if (isActivityStatus) return commonStatusColor(status);
    return appSecondaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      padding: padding ?? EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: boxDecorationDefault(
        color: backgroundColor ?? getStatusBackgroundColor(),
        borderRadius: borderRadius ?? radius(),
      ),
      child: Text(getStatusText().validate(), style: textStyle ?? boldTextStyle(size: isAppointmentStatus ? 12 : 10, color: Colors.white, letterSpacing: 1)),
    );
  }
}
