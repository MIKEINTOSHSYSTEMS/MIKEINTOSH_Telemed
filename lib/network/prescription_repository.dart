import 'package:kivicare_flutter/model/prescription_model.dart';
import 'package:kivicare_flutter/model/send_prescription_mail.dart';
import 'package:kivicare_flutter/network/network_utils.dart';

//Prescription List
Future<PrescriptionModel> getPrescriptionResponse(String id) async {
  return PrescriptionModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/list?encounter_id=$id'))));
}

Future<PrescriptionData> savePrescriptionData(Map request) async {
  return PrescriptionData.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/save', request: request, method: HttpMethod.POST))));
}

Future<PrescriptionData> deletePrescriptionData(Map request) async {
  return PrescriptionData.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/delete', request: request, method: HttpMethod.POST))));
}

Future<SendPrescriptionMail> sendPrescriptionMail({required int encounterId}) async {
  return SendPrescriptionMail.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/prescription/prescription-mail', method: HttpMethod.POST, request: {"encounter_id": '$encounterId'}))));
}

// End Prescription
