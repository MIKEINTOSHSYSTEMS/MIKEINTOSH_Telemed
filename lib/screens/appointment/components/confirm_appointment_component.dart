import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/confirm_appointment_response_model.dart';
import 'package:kivicare_flutter/network/appointment_repository.dart';
import 'package:kivicare_flutter/screens/appointment/appointment_functions.dart';
import 'package:kivicare_flutter/screens/appointment/components/confirm_appointment_step1_component.dart';
import 'package:kivicare_flutter/screens/appointment/components/success_full_payment_component.dart';
import 'package:kivicare_flutter/screens/doctor/fragments/appointment_fragment.dart';
import 'package:kivicare_flutter/screens/patient/screens/web_view_payment_screen.dart';
import 'package:kivicare_flutter/services/razor_pay_service.dart';
import 'package:kivicare_flutter/services/stripe_pay_service.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

class ConfirmAppointmentComponent extends StatefulWidget {
  final int? appointmentId;

  ConfirmAppointmentComponent({
    this.appointmentId,
  });

  @override
  _ConfirmAppointmentScreenState createState() => _ConfirmAppointmentScreenState();
}

class _ConfirmAppointmentScreenState extends State<ConfirmAppointmentComponent> {
  bool isUpdate = false;

  int currentIndex = 0;
  bool paymentStatus = false;

  String? selectedPaymentOption;

  ConfirmAppointmentResponseModel? appointmentBookingData;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    appStore.setLoading(false);
    isUpdate = widget.appointmentId != null;
  }

  Future<void> saveAppointment() async {
    Map<String, dynamic> req = {
      "appointment_start_date": appointmentAppStore.selectedAppointmentDate.getFormattedDate(SAVE_DATE_FORMAT),
      "appointment_start_time": appointmentAppStore.mSelectedTime.validate().trim(),
      "doctor_id": appointmentAppStore.mDoctorSelected?.iD.validate().toString().trim(),
      "description": appointmentAppStore.mDescription.validate().trim(),
      "status": "1",
    };
    if (isUpdate) {
      req.putIfAbsent('id', () => widget.appointmentId);
    }
    if (isPatient() && appStore.paymentMode.isNotEmpty) {
      req.putIfAbsent('payment_mode', () => appStore.paymentMode);
    }

    if (isDoctor() || isReceptionist()) {
      req.putIfAbsent("patient_id", () => appointmentAppStore.mPatientId);
    } else {
      req.putIfAbsent("patient_id", () => userStore.userId.toString());
    }

    if (isProEnabled() && appointmentAppStore.mClinicSelected != null) {
      req.putIfAbsent("clinic_id", () => appointmentAppStore.mClinicSelected!.id.validate());
    } else {
      req.putIfAbsent("clinic_id", () => "${userStore.userClinicId}");
    }

    if (multiSelectStore.selectedService.isNotEmpty) {
      multiSelectStore.selectedService.forEachIndexed((index, element) {
        req.putIfAbsent("visit_type[$index]", () => multiSelectStore.selectedService[index].id.validate());
      });
    }

    saveAppointmentApi(data: req, files: appointmentAppStore.reportList.map((element) => File(element.path.validate())).toList()).then((value) async {
      appointmentBookingData = value;

      appStore.setLoading(false);

      if (isUpdate) {
        redirectionCase(context, message: value.message.validate(), finishCount: 2).then((value) {});
      } else {
        if (!value.isAppointmentAlreadyBooked.validate()) {
          if (isPatient()) {
            paymentRedirection();
          } else {
            redirectionCase(context, message: value.message.validate());
          }
        } else {}
      }
    }).catchError((error) {
      appStore.setLoading(false);
      appointmentAppStore.clearAll();
      if (isPatient()) {
        for (int i = 0; i < 4; i++) finish(context, true);
      } else {
        for (int i = 0; i < 3; i++) finish(context, true);
      }
    });
  }

  Future<void> paymentRedirection() async {
    if (appStore.paymentMode == PAYMENT_RAZORPAY) {
      RazorPayService.initRazorPay(
        context: context,
        paymentStatusCallback: (payment) {
          currentIndex = 1;
          this.paymentStatus = payment;
          setState(() {});
        },
        appointmentBookingData: appointmentBookingData!,
      );
      RazorPayService.checkoutPayment();
    } else if (appStore.paymentMode == PAYMENT_STRIPE) {
      await stripeServices.init(
        data: appointmentBookingData!,
        isTest: appointmentBookingData!.orderData!.isTest,
        paymentStatusCallback: (payment) {
          currentIndex = 1;
          this.paymentStatus = payment;
          setState(() {});
        },
      );
    } else if (appStore.paymentMode == PAYMENT_WOOCOMMERCE) {
      WebViewPaymentScreen(checkoutUrl: appointmentBookingData!.woocommerceRedirect.validate()).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {});
    } else {
      redirectionCase(context, message: appointmentBookingData!.message.validate(), finishCount: 5);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(18),
          decoration: boxDecorationDefault(color: context.cardColor),
          child: <Widget>[
            ConfirmAppointmentStep1Component(
              isUpdate: isUpdate,
              changeIndexCallback: (paymentMethod) async {
                selectedPaymentOption = paymentMethod;

                saveAppointment();
                setState(() {});
              },
            ),
            SuccessFullPaymentComponent(paymentStatus: paymentStatus)
          ][currentIndex],
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              stepCountWidget(
                name: currentIndex == 0 ? locale.lblAppointmentSummary : 'Payment Summary',
                currentCount: currentIndex + 1,
                totalCount: 2,
                percentage: currentIndex == 0 ? 0.50 : 1.0,
                showSteps: false,
              ).expand(),
              Icon(Icons.close).appOnTap(() {
                if (!appStore.isLoading && currentIndex == 0)
                  finish(context);
                else {
                  if (currentIndex == 1) {
                    for (int i = 0; i < 4; i++) finish(context, true);
                  }
                }
              })
            ],
          ),
        ),
      ],
    );
  }
}
