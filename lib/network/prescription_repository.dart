import 'package:kivicare_flutter/model/base_response.dart';
import 'package:kivicare_flutter/model/prescription_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

//Prescription List
Future<PrescriptionModel> getPrescriptionResponseAPI(String id) async {
  return PrescriptionModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/list?encounter_id=$id'))));
}

Future<List<String>> getPrescriptionNameAndFrequencyAPI({required String id, bool isFrequency = false}) async {
  PrescriptionModel res = PrescriptionModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/list?encounter_id=$id'))));

  if (isFrequency) {
    return res.prescriptionData!.map((e) => e.frequency.validate()).toList();
  }
  return res.prescriptionData!.map((e) => e.name.validate()).toList();
}

Future<PrescriptionData> savePrescriptionDataAPI(Map request) async {
  return PrescriptionData.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/save', request: request, method: HttpMethod.POST))));
}

Future<PrescriptionData> deletePrescriptionDataAPI(Map request) async {
  return PrescriptionData.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/delete', request: request, method: HttpMethod.POST))));
}

Future<BaseResponses> sendPrescriptionMailAPI({required int encounterId}) async {
  return BaseResponses.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/prescription-mail', method: HttpMethod.POST, request: {"encounter_id": '$encounterId'}))));
}

// End Prescription
