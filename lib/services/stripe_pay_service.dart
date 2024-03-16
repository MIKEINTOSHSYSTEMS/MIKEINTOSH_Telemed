import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/confirm_appointment_response_model.dart';
import 'package:momona_healthcare/model/stripe_pay_model.dart';
import 'package:momona_healthcare/network/bill_repository.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/screens/doctor/fragments/appointment_fragment.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class StripeServices {
  static late ConfirmAppointmentResponseModel appointmentBookingData;

  bool isTest = false;
  static late Function(bool) paymentStatusBool;

  init({
    required ConfirmAppointmentResponseModel data,
    required bool isTest,
    required Function(bool) paymentStatusCallback,
  }) async {
    appointmentBookingData = data;
    paymentStatusBool = paymentStatusCallback;

    this.isTest = isTest;
    appStore.setLoading(true);
    Stripe.publishableKey = data.orderData!.stripePublishableKey.validate();
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';

    await Stripe.instance.applySettings().catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
      throw e.toString();
    }).whenComplete(() {
      stripePay();
    });
  }

  //StripPayment
  void stripePay() async {
    http.Request request = http.Request(HttpMethodType.POST.name, Uri.parse(STRIPE_URL));

    request.bodyFields = {
      'amount': '${(appointmentBookingData.orderData!.amount.validate() * 100).toInt()}',
      'currency': appointmentBookingData.orderData!.currencyCode.validate(),
      'description': APP_NAME_TAG_LINE,
    };

    request.headers.addAll(buildHeaderTokens(extraKeys: {'isStripePayment': true, 'stripeKeyPayment': appointmentBookingData.orderData!.stripeSecretKey.validate()}));

    appStore.setLoading(true);

    await request
        .send()
        .then((value) {
          http.Response.fromStream(value).then((response) async {
            if (response.statusCode.isSuccessful()) {
              StripePayModel res = StripePayModel.fromJson(await handleResponse(response));

              SetupPaymentSheetParameters setupPaymentSheetParameters = SetupPaymentSheetParameters(
                paymentIntentClientSecret: res.clientSecret.validate(),
                style: appThemeMode,
                appearance: PaymentSheetAppearance(colors: PaymentSheetAppearanceColors(primary: appPrimaryColor)),
                applePay: PaymentSheetApplePay(merchantCountryCode: STRIPE_MERCHANT_COUNTRY_CODE),
                googlePay: PaymentSheetGooglePay(merchantCountryCode: STRIPE_MERCHANT_COUNTRY_CODE, testEnv: isTest),
                merchantDisplayName: APP_NAME,
                customerId: userStore.userId.toString(),
                customerEphemeralKeySecret: isAndroid ? res.clientSecret.validate() : null,
                setupIntentClientSecret: res.clientSecret.validate(),
                billingDetails: BillingDetails(name: userStore.userDisplayName, email: userStore.userEmail),
              );

              await Stripe.instance.initPaymentSheet(paymentSheetParameters: setupPaymentSheetParameters).then((value) async {
                await Stripe.instance.presentPaymentSheet().then((val) async {
                  toast("Wait for a while we're completing your appointment booking");
                  savePaymentResponse(paymentStatus: ConstantKeys.paymentCapturedKey);
                });
              });
            } else if (response.statusCode == 400) {
              savePaymentResponse(paymentStatus: ConstantKeys.paymentFailedKey);
              toast(locale.lblStripeTestCredential);
            } else {
              toast(parseStripeError(response.body), print: true);
            }
          });
        })
        .whenComplete(() {})
        .catchError((e) {
          savePaymentResponse(paymentStatus: ConstantKeys.paymentFailedKey);
          appStore.setLoading(false);
          toast(e.toString(), print: true);

          throw e.toString();
        });
  }

  savePaymentResponse({required String paymentStatus}) {
    Map<String, dynamic> request = {
      "status": paymentStatus,
      "appointment_id": appointmentBookingData.appointmentId,
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
      toast('Payment Failed');
    });
  }
}

StripeServices stripeServices = StripeServices();
