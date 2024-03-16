import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_session_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/constants.dart';

//region Doctor Sessions

Future<DoctorSessionModel> getDoctorSessionDataAPI({String? clinicId = ''}) async {
  if (!appStore.isConnectedToInternet) return DoctorSessionModel();
  return DoctorSessionModel.fromJson(await (handleResponse(
      await buildHttpResponse('${ApiEndPoints.settingEndPoint}/${EndPointKeys.getDoctorClinicSessionEndPointKey}?${ConstantKeys.clinicIdKey}=${clinicId != null ? clinicId : ''}'))));
}

Future addDoctorSessionDataAPI(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/setting/save-doctor-clinic-session', request: request, method: HttpMethod.POST));
}

Future deleteDoctorSessionDataAPI(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/setting/delete-doctor-clinic-session', request: request, method: HttpMethod.POST));
}

//endregion
