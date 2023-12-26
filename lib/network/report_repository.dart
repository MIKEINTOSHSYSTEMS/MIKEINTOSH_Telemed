import 'dart:io';

import 'package:http/http.dart';
import 'package:kivicare_flutter/model/report_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

//Report

Future<ReportModel> getReportData({int? patientId}) async {
  return ReportModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/patient/get-patient-report?patient_id=$patientId&page=1&limit=10'))));
}

Future<bool> addReportData(Map data, {File? file, String? toastMessage}) async {
  var multiPartRequest = await getMultiPartRequest('kivicare/api/v1/patient/upload-patient-report');

  multiPartRequest.fields['name'] = data['name'];
  multiPartRequest.fields['patient_id'] = data['patient_id'];
  multiPartRequest.fields['date'] = data['date'];

  if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('upload_report', file.path));

  multiPartRequest.headers.addAll(buildHeaderTokens());

  Response response = await Response.fromStream(await multiPartRequest.send());

  if (response.statusCode.isSuccessful()) {
    toast("Report added successfully");
    return true;
  } else {
    toast(errorSomethingWentWrong);
    return false;
  }
}

Future deleteReport(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/patient/delete-patient-report', request: request, method: HttpMethod.POST));
}

//End Report
