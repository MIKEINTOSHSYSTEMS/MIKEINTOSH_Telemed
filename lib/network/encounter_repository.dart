import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/medical_history_model.dart';
import 'package:kivicare_flutter/model/patient_encounter_list_model.dart';
import 'package:kivicare_flutter/model/telemed_status_changed.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

// Start Encounter List

Future addEncounterData(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/save', request: request, method: HttpMethod.POST));
}

Future deleteEncounterData(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/delete', request: request, method: HttpMethod.POST));
}

Future<List<PatientEncounterData>> getPatientEncounterList(int? patientId, {int? page, required List<PatientEncounterData> encounterList, Function(bool)? lastPageCallback, Function(int)? getTotalPatient}) async {
  appStore.setLoading(true);
  List<String> param = [];

  if (!isReceptionist()) {
    if (patientId != null) param.add('patient_id=$patientId');
  }

  PatientEncounterListModel res = PatientEncounterListModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/encounter/get-encounter-list', page: page, params: param))));

  getTotalPatient?.call(res.total.validate().toInt());

  if (page == 1) encounterList.clear();

  lastPageCallback?.call(res.patientEncounterData.validate().length != PER_PAGE);

  encounterList.addAll(res.patientEncounterData.validate());

  appStore.setLoading(false);
  return encounterList;
}

// Future<PatientEncounterListModel> getPatientEncounterList(int? req, {int? page}) async {
//   if (isReceptionist()) {
//     return PatientEncounterListModel.fromJson(
//       await (handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/get-encounter-list?limit$PER_PAGE&page=$page'))),
//     );
//   } else {
//     return PatientEncounterListModel.fromJson(
//       await (handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/get-encounter-list?limit$PER_PAGE&page=$page&patient_id=$req'))),
//     );
//   }
// }

Future encounterClose(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/close', request: request, method: HttpMethod.POST));
}

// End Encounter List

Future deletePatientData(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/patient/delete-patient', request: request, method: HttpMethod.POST));
}

//Encounter Details API
Future<MedicalHistoryModel> getMedicalHistoryResponse(int id, String type) async {
  MedicalHistoryModel value = MedicalHistoryModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/get-medical-history?encounter_id=$id&type=$type'))));
  return value;
}

Future<EncounterType> saveMedicalHistoryData(Map request) async {
  return EncounterType.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/patient/save-medical-history', request: request, method: HttpMethod.POST))));
}

Future<EncounterType> deleteMedicalHistoryData(Map request) async {
  return EncounterType.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/patient/delete-medical-history', request: request, method: HttpMethod.POST))));
}

Future<TelemedStatus> changeTelemedType({required Map<String, dynamic> request}) async {
  return TelemedStatus.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/user/change-telemed-type', request: request, method: HttpMethod.POST))));
}

//End of Encounter Details API
