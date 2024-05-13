import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/base_response.dart';
import 'package:kivicare_flutter/model/encounter_model.dart';
import 'package:kivicare_flutter/model/encounter_type_model.dart';
import 'package:kivicare_flutter/model/patient_encounter_list_model.dart';
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

Future<List<EncounterModel>> getPatientEncounterList({
  int? id,
  int? page,
  required List<EncounterModel> encounterList,
  Function(bool)? lastPageCallback,
  Function(int)? getTotalPatient,
}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }

  List<String> param = [];

  if (id != null) {
    param.add('patient_id=$id');
  }
  if (isReceptionist()) {
    param.add('clinic_id=${userStore.userClinicId}');
  }
  if (isDoctor()) param.add('doctor_id=${userStore.userId}');

  PatientEncounterListModel res =
      PatientEncounterListModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/encounter/get-encounter-list', page: page, params: param))));

  getTotalPatient?.call(res.total.validate().toInt());

  if (page == 1) encounterList.clear();

  lastPageCallback?.call(res.patientEncounterData.validate().length != PER_PAGE);

  encounterList.addAll(res.patientEncounterData.validate());

  appStore.setLoading(false);
  return encounterList;
}

Future<BaseResponses> encounterClose(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/close', request: request, method: HttpMethod.POST)));
}

// End Encounter List

Future<BaseResponses> deletePatientData(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/patient/delete-patient', request: request, method: HttpMethod.POST)));
}

Future<EncounterType> saveMedicalHistoryData(Map request) async {
  return EncounterType.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/patient/save-medical-history', request: request, method: HttpMethod.POST))));
}

Future<BaseResponses> deleteMedicalHistoryData(Map request) async {
  return BaseResponses.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/patient/delete-medical-history', request: request, method: HttpMethod.POST))));
}

//End of Encounter Details API
