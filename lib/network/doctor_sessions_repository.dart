import 'package:kivicare_flutter/model/doctor_schedule_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';

//region Doctor Sessions

Future<DoctorSessionModel> getDoctorSessionData({int? clinicData}) async {
  return DoctorSessionModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/setting/get-doctor-clinic-session?clinic_id=${clinicData != null ? clinicData : ''}'))));
}

Future addDoctorSessionData(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/setting/save-doctor-clinic-session', request: request, method: HttpMethod.POST));
}

Future deleteDoctorSessionData(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/setting/delete-doctor-clinic-session', request: request, method: HttpMethod.POST));
}

//endregion
