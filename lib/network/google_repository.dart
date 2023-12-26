import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/response_model.dart';
import 'package:kivicare_flutter/model/user_configuration.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

// /kivicare/api/v1/doctor/get-zoom-configuration

//region Google Calender
Future<ResponseModel> connectGoogleCalendar({required Map<String, dynamic> request}) async {
  return ResponseModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/google-calendar/connect-doctor', request: request, method: HttpMethod.POST))));
}

Future<ResponseModel> disconnectGoogleCalendar() async {
  return ResponseModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/google-calendar/disconnect-doctor'))));
}

//region Google Calender
Future<ResponseModel> connectMeet({required Map<String, dynamic> request}) async {
  return ResponseModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/connect-googlemeet-doctor', request: request, method: HttpMethod.POST))));
}

Future<ResponseModel> disconnectMeet({required Map<String, dynamic> request}) async {
  return ResponseModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/disconnect-googlemeet-doctor', request: request, method: HttpMethod.POST))));
}

Future<UserConfiguration> getConfiguration() async {
  UserConfiguration value = UserConfiguration.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/user/get-configuration'))));

  appStore.setUserProEnabled(value.isKiviCareProOnName.validate(), initiliaze: true);
  appStore.setUserTelemedOn(value.isTeleMedActive.validate(), initiliaze: true);
  appStore.setUserMeetService(value.isKiviCareGooglemeetActive.validate(), initiliaze: true);
  appStore.setUserEnableGoogleCal(value.is_enable_google_cal.validate(), initiliaze: true);
  appStore.setUserDoctorGoogleCal(value.is_enable_doctor_gcal.validate(), initiliaze: true);
  appStore.setTelemedType(value.telemed_type.validate().toString(), initiliaze: true);
  appStore.setRestrictAppointmentPost(value.restrict_appointment!.post.validate().toInt(), initiliaze: true);
  appStore.setRestrictAppointmentPre(value.restrict_appointment!.pre.validate().toInt(), initiliaze: true);
  return value;
}

//endregion
