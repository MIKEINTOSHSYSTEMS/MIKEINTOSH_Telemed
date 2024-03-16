import 'dart:async';

import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/configuration_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

//region configuration

StreamController configurationController = StreamController.broadcast();

Future<void> getConfigurationAPI() async {
  ConfigurationModel value = ConfigurationModel.fromJson(await (handleResponse(await buildHttpResponse(ApiEndPoints.getConfigurationEndPoint))));
  appStore.setUserProEnabled(value.isKiviCareProOnName.validate(), initialize: true);
  appStore.setGoogleMeetEnabled(value.isKiviCareGoogleMeetActive.validate());
  appStore.setGlobalDateFormat(value.globalDateFormat.validate(), initialize: true);
  appStore.setGlobalUTC(value.utc.validate());
  userStore.setTermsAndCondition(value.termsEndCondition.validate());
  appStore.setRestrictAppointmentPost(value.restrictAppointment!.post.validate(value: '365').toInt(), initialize: true);
  appStore.setRestrictAppointmentPre(value.restrictAppointment!.pre.validate().toInt(), initialize: true);
  appStore.setNonce(value.nonce.validate());
  if (value.paymentMethod != null) {
    setValue(SharedPreferenceKey.paymentMethodsKey, value.paymentMethod!.toJson());
    paymentMethodList.clear();
    paymentMethodImages.clear();
    paymentModeList.clear();

    if (value.paymentMethod!.paymentRazorpay.validate().isNotEmpty) {
      appStore.setRazorPay(true);
      appStore.setRazorPayMethod(value.paymentMethod!.paymentRazorpay.validate());
      paymentMethodList.add(appStore.paymentRazorpay);
      paymentMethodImages.add(ic_razorpay);
      paymentModeList.add(PAYMENT_RAZORPAY);
    }
    if (value.paymentMethod!.paymentStripePay.validate().isNotEmpty) {
      appStore.setStripePay(true);
      appStore.setStripePayMethod(value.paymentMethod!.paymentStripePay.validate());
      paymentMethodList.add(appStore.paymentStripe);
      paymentMethodImages.add(ic_stripePay);
      paymentModeList.add(PAYMENT_STRIPE);
    }
    if (value.paymentMethod!.paymentWoocommerce.validate().isNotEmpty) {
      appStore.setWoocommerce(true);
      appStore.setWoocommerceMethod(value.paymentMethod!.paymentWoocommerce.validate());
      paymentMethodList.add(appStore.paymentWoocommerce);
      paymentMethodImages.add(ic_wooCommerce);
      paymentModeList.add(PAYMENT_WOOCOMMERCE);
    }
    if (value.paymentMethod!.paymentOffline.validate().isNotEmpty) {
      appStore.setOffLinePayment(true);
      appStore.setOffLinePaymentMethod(value.paymentMethod!.paymentOffline.validate());
      paymentMethodList.add(appStore.paymentOffline);
      paymentMethodImages.add(ic_payOffline);
      paymentModeList.add(PAYMENT_OFFLINE);
    }
  }
  if (appStore.userProEnabled.validate()) {
    permissionStore.setUserPermission(value.permissions);
    permissionStore.setAppointmentModulePermission(value.permissions?.appointmentModule);
    permissionStore.setBillingModulePermission(value.permissions?.billingModule);
    permissionStore.setClinicModulePermission(value.permissions?.clinicModule);
    permissionStore.setClinicDetailModulePermission(value.permissions?.clinicalDetailModule);
    permissionStore.setDoctorDashboardPermission(value.permissions?.dashboardModule);
    permissionStore.setDoctorModulePermission(value.permissions?.doctorModule);
    permissionStore.setEncounterModulePermission(value.permissions?.encounterModule);
    permissionStore.setEncounterTemplateModulePermission(value.permissions?.encountersTemplateModule);
    permissionStore.setHolidayModulePermission(value.permissions?.holidayModule);
    permissionStore.setSessionPermission(value.permissions?.sessionModule);
    permissionStore.setOtherModulePermission(value.permissions?.otherModule);
    permissionStore.setPatientModulePermission(value.permissions?.patientModule);
    permissionStore.setPatientReportModulePermission(value.permissions?.patientReportModule);
    permissionStore.setPrescriptionModulePermission(value.permissions?.prescriptionModule);
    permissionStore.setServiceModulePermission(value.permissions?.serviceModule);
    permissionStore.setStaticDataModulePermission(value.permissions?.staticDataModule);
  }
}

//endregion

//region configuration

Future<void> saveLanguageApi(Map<String, dynamic> request) async {
  await (handleResponse(await buildHttpResponse(ApiEndPoints.saveLanguageApiEndPoint)));
}

//endregion
