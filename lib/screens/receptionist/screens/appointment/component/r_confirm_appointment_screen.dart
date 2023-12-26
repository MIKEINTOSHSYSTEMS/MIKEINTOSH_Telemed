import 'dart:io';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/appointment_respository.dart';
import 'package:kivicare_flutter/network/doctor_list_repository.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/int_extesnions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

class RConfirmAppointmentScreen extends StatefulWidget {
  final int? appointmentId;

  RConfirmAppointmentScreen({this.appointmentId});

  @override
  _RConfirmAppointmentScreenState createState() => _RConfirmAppointmentScreenState();
}

class _RConfirmAppointmentScreenState extends State<RConfirmAppointmentScreen> {
  bool isUpdate = false;
  bool mIsConfirmed = false;

  DateTime appointmentDateTime = DateTime.parse(appointmentAppStore.selectedAppointmentDate.getFormattedDate(CONVERT_DATE));

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.appointmentId != null;
    getDoctor();
  }

  void saveAppointment() {
    appStore.setLoading(true);
    Map<String, dynamic> req = {
      "id": isUpdate ? "${widget.appointmentId}" : "",
      "appointment_start_date": "${appointmentAppStore.selectedAppointmentDate.getFormattedDate(CONVERT_DATE)}",
      "appointment_start_time": "${appointmentAppStore.mSelectedTime.validate()}",
      "doctor_id": "${appointmentAppStore.mDoctorSelected?.iD.validate()}",
      "clinic_id": "${getIntAsync(USER_CLINIC)}",
      "description": "${appointmentAppStore.mDescription.validate()}",
      "patient_id": '${appointmentAppStore.mPatientId.validate()}',
      "status": '${appointmentAppStore.mStatusSelected.validate()}',
    };

    if (appointmentAppStore.selectedService.isNotEmpty) {
      appointmentAppStore.selectedService.forEachIndexed((index, element) {
        req.putIfAbsent("visit_type[$index]", () => '${appointmentAppStore.selectedService[index]}');
      });
    }
    if (appointmentAppStore.reportList.isNotEmpty) {
      req.putIfAbsent("attachment_count", () => "${appointmentAppStore.reportList.length}");

      appointmentAppStore.reportList.forEachIndexed((index, element) {
        req.putIfAbsent("appointment_report_$index", () => File(element.path.validate()).path);
      });
    }

    log(req);
    appointmentRequest.addAppointment(req).then((value) async {
      if (value != null) {
        mIsConfirmed = true;
        setState(() {});
        appStore.setLoading(false);
        await 500.milliseconds.delay;

        finish(context);
        finish(context);
        finish(context, true);
        appointmentAppStore.clearAll();
        LiveStream().emit(APP_UPDATE, true);
        LiveStream().emit(UPDATE, true);
      }
      appStore.setLoading(false);
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget confirmedAppointment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(appointment_confirmation, height: 180, width: 180),
        30.height,
        Text(locale.lblAppointmentIsConfirmed, style: primaryTextStyle(size: 24), textAlign: TextAlign.center),
        20.height,
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(locale.lblThanksForBooking, style: secondaryTextStyle()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.clear).onTap(
              () {
                finish(context, false);
                appStore.setLoading(false);
              },
            ),
          ),
          8.height,
          Image.asset(ic_confirm_appointment, height: 50, width: 50),
          30.height,
          Text(
            "Dr.${getStringAsync(FIRST_NAME)}, ${locale.lblAppointmentConfirmation}",
            style: primaryTextStyle(size: 20),
            textAlign: TextAlign.center,
          ),
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(FontAwesomeIcons.calendarCheck, size: 20),
              8.width,
              Text(
                '${appointmentDateTime.weekday.validate().getFullWeekDay()}, ${appointmentDateTime.month.validate().getMonthName()} ${appointmentDateTime.day.validate()}, ${appointmentDateTime.year.validate()}',
                style: boldTextStyle(size: 16),
              ).center().flexible(),
            ],
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${appointmentAppStore.mSelectedTime}", style: boldTextStyle(size: 18), textAlign: TextAlign.center).expand(),
              VerticalDivider(color: viewLineColor, thickness: 1).withHeight(20),
              16.width,
              Text("${appointmentAppStore.mPatientSelected}", style: boldTextStyle(size: 18)).expand(),
            ],
          ),
          16.height,
          if (appointmentAppStore.mDescription.validate().isNotEmpty)
            Text(
              '${appointmentAppStore.mDescription}',
              style: primaryTextStyle(),
              textAlign: TextAlign.center,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          8.height,
          Observer(
            builder: (_) => Align(
              alignment: Alignment.bottomCenter,
              child: AppButton(
                text: locale.lblConfirmAppointment,
                textStyle: boldTextStyle(color: Colors.white),
                onTap: () async {
                  saveAppointment();
                },
              ).withWidth(context.width()),
            ).visible(!appStore.isLoading, defaultWidget: Loader()),
          ),
        ],
      ).visible(
        !mIsConfirmed,
        defaultWidget: confirmedAppointment(),
      ),
    );
  }
}
