import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/confirm_appointment_response_model.dart';
import 'package:kivicare_flutter/network/bill_repository.dart';
import 'package:kivicare_flutter/screens/doctor/fragments/appointment_fragment.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayService {
  static late Razorpay razorPay;
  static late ConfirmAppointmentResponseModel appointmentResponse;
  static late BuildContext ctx;

  static late Function(bool) paymentStatusBool;

  static void initRazorPay({
    required ConfirmAppointmentResponseModel appointmentBookingData,
    required BuildContext context,
    String? msg,
    Function(bool)? paymentStatusCallback,
  }) {
    razorPay = Razorpay();
    ctx = context;
    appointmentResponse = appointmentBookingData;

    paymentStatusBool = paymentStatusCallback!;
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, RazorPayService.onPaymentComplete);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, RazorPayService.onError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, RazorPayService.onWalletPayment);
  }

  static void onPaymentComplete(PaymentSuccessResponse response) {
    toast("Wait for a while we're completing your appointment booking");
    Map<String, dynamic> request = {
      "status": ConstantKeys.paymentFailedKey,
      "appointment_id": appointmentResponse.appointmentId,
    };
    appStore.setLoading(true);
    savePayment(paymentResponse: request).then((v) {
      appointmentStreamController.add(true);
      toast(locale.lblAppointmentBookedSuccessfully);
      appStore.setLoading(false);
      appStore.setPaymentMode('');
      paymentStatusBool.call(true);
      multiSelectStore.setTaxData(null);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  static void onError(PaymentFailureResponse response) {
    toast(response.message);
    appStore.setLoading(false);

    Map<String, dynamic> request = {
      "status": ConstantKeys.paymentCapturedKey,
      "appointment_id": appointmentResponse.appointmentId,
    };
    appStore.setLoading(true);
    savePayment(paymentResponse: request).then((v) {
      appointmentStreamController.add(true);
      appStore.setLoading(false);
      appStore.setPaymentMode('');
      paymentStatusBool.call(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  static void onWalletPayment(ExternalWalletResponse response) {}

  static Future<void> checkoutPayment() async {
    Map<String, dynamic> options = {
      'key': appointmentResponse.orderData!.razorKey,
      'amount': appointmentResponse.orderData!.amount.validate(),
      'name': appointmentResponse.orderData!.receiverName,
      'image': 'https://kivicare.io/wp-content/uploads/2022/09/footer-logo.png',
      'theme.color': appointmentResponse.orderData!.themeData,
      'description': APP_NAME_TAG_LINE,
      'currency': appointmentResponse.orderData!.currencyCode,
      'prefill': {
        'contact': appointmentResponse.orderData!.prefillData!.contactNumber,
        'email': appointmentResponse.orderData!.prefillData!.email.validate(),
        'name': appointmentResponse.orderData!.prefillData!.name.validate(),
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      toast(e.toString());
      throw e;
    }
  }
}
